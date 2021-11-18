class DailyWithdrawTransactionRepository < Hanami::Repository
  def all_from_date(date)
    daily_withdraw_transactions.where("created_at BETWEEN (date_trunc('day', ?::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', ?::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')", date, date)
  end

  def find_with_user_and_date(user_id, date)
    all_from_date(date).where(user_id: user_id)
  end
end
