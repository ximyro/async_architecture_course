class DepositTransactionRepository < Hanami::Repository
  def all_for_period(start_date, end_date)
    deposit_transactions.where("created_at BETWEEN ? AND ?", start_date, end_date)
  end

  def find_with_user_and_period(user_id, started_at, ended_at)
    all_for_period(started_at, ended_at).where(user_id: user_id)
  end
end
