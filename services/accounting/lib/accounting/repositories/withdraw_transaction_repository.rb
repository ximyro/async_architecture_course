class WithdrawTransactionRepository < Hanami::Repository
  def all_from_date(date)
    deposit_transactions.where("created_at BETWEEN (date_trunc('day', ?::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', ?::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')", date, date)
  end
end
