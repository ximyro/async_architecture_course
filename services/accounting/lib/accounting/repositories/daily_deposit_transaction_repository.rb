class DailyDepositTransactionRepository < Hanami::Repository
  def all_ordered_by_date
    daily_management_statistics.order { created_at.desc }
  end

  def all_from_date(date)
    daily_deposit_transactions.where("created_at BETWEEN (date_trunc('day', ?::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', ?::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')", date, date)
  end

  def find_with_user_and_date(user_id, date)
    all_from_date(date).where(user_id: user_id)
  end
end
