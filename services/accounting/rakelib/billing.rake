namespace :billing do
  desc 'Close'
  task close_billing_cycle_period: :environment do
    #CloseBillinCyclePeriud -> BillingCycleClosed      -> NotifyUser
    #-> PayedTransactionApplied -> PayMoney
    deposit_transactions_repo = DepositTransactionRepository.new
    withdraw_transactions_repo = WithdrawTransactionRepository.new

    yesterday = Time.now - 24 * 60 * 60
    deposit_transactions_repo.all_from_yesterday(yesterday)
    withdraw_transactions_repo.all_from_yesterday(yesterday)
  end
end
