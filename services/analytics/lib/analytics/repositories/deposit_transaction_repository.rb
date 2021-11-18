class DepositTransactionRepository < Hanami::Repository
  def create_or_update(data, date)
    create(
      date: Time.at(date.to_i),
      task_public_id: data['task_public_id'],
      user_public_id: data['user_public_id'],
      amount: BigDecimal(data['amount']),
      reason: data['reason'],
      description: data['description']
    )
  end

  def with_max_amount_per_day(date)
    condition = from_day_condition(date)
    deposit_transactions.read("SELECT id, max(amount) as amount, task_public_id FROM deposit_transactions WHERE #{condition} GROUP BY id LIMIT 1").one
  end


  def from_day_condition(date)
    "date BETWEEN (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')"
  end
end
