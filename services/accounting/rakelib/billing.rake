namespace :billing do
  desc 'Close billing cycle period'
  task close_billing_cycle_period: :environment do
    #CloseBillinCyclePeriud -> BillingCycleClosed      -> NotifyUser
    #-> PayedTransactionApplied -> PayMoney
    deposit_transactions_repo = DepositTransactionRepository.new
    withdraw_transactions_repo = WithdrawTransactionRepository.new
    daily_deposit_transactions_repo = DailyDepositTransactionRepository.new
    daily_withdraw_transactions_repo = DailyWithdrawTransactionRepository.new
    users_repo = UserRepository.new

    yesterday = Time.now - 24 * 60 * 60
    deposit_transactions = deposit_transactions_repo.all_from_date(yesterday).to_a.group_by(&:user_id)
    withdraw_transactions = withdraw_transactions_repo.all_from_date(yesterday).to_a.group_by(&:user_id)
    daily_stats = {}

    deposit_transactions.each do |k, transactions|
      daily_stats[k] = transactions.map(&:amount).reduce(:+)
      daily_deposit_transactions_repo.create(
        reason: "Выплата за #{yesterday.strftime('%y/%d/%m')}",
        amount: transactions.map(&:amount).reduce(:+),
        transaction_ids: transactions.map(&:id),
        user_id: k
      )
    end

    withdraw_transactions.each do |k, transactions|
      if daily_stats[k]
        daily_stats[k] -= transactions.map(&:amount).reduce(:+)
      end
      daily_withdraw_transactions_repo.create(
        reason: "Списание за #{yesterday.strftime('%y/%d/%m')}",
        amount: transactions.map(&:amount).reduce(:+),
        transaction_ids: transactions.map(&:id),
        user_id: k
      )
    end

    users_with_positive_balance = daily_stats.select { |_k, v| v.positve? }
    users_with_positive_balance.each do |k, _v|
      users_repo.set_zero_balance(k)
      Notifier.notify_user(k)
    end

    Producer.call(
      Events::BillingCycleClosed.new(
        date: yesterday.to_s
      ),
      'billing-cycle'
    )
  end
end
