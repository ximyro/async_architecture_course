class TransactionRepository
  def for_period(user_id, start_date = nil, end_date = nil)
    if start_date.nil? || end_date.nil?
      date = users_repo.last_date_with_statistics(user_id)
      start_date = Time.now(date.year, date.month, date.day)
      end_date = Time.now(date.year, date.month, date.day, 23, 59, 59)
    end

    transactions = deposit_transactions_repo.find_with_user_and_period(
      user_id,
      start_date,
      end_date
    ).to_a
    transactions += withdraw_transactions_repo.find_with_user_and_period(
      user_id,
      start_date,
      end_date
    ).to_a

    transactions.sort_by!(&:created_at)
  end

  def deposit_transactions_repo
    @_deposit_transactions_repo ||= DepositTransactionRepository.new
  end

  def withdraw_transactions_repo
    @_withdraw_transactions_repo ||= WithdrawTransactionRepository.new
  end

  def users_repo
    @_users_repo ||= UserRepository.new
  end
end
