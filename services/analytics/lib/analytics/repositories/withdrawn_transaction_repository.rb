class WithdrawnTransactionRepository < Hanami::Repository
  def create_or_update(data, date)
    create(
      date: Time.at(date),
      task_public_id: data['task_public_id'],
      user_public_id: data['user_public_id'],
      amount: data['amount'],
      reason: data['reason'],
      description: data['description']
    )
  end

  def find_users_count_with_debt(date)
    query = "wt.date BETWEEN (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')"
    dt_query = "dt.date BETWEEN (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')"

    withdrawn_transactions.read(
      "SELECT COUNT(wt.user_public_id) from withdrawn_transactions wt
        LEFT JOIN deposit_transactions dt on dt.user_public_id = wt.user_public_id AND #{dt_query}
      WHERE #{query}
      GROUP BY wt.user_public_id
      HAVING(SUM(dt.amount) - SUM(wt.amount) < 0)
      "
    )&.map&.first&.dig(:count)
  end

  def find_management_earn(date)
    query = "wt.date BETWEEN (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')"
    dt_query = "dt.date BETWEEN (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE)) AND (date_trunc('day', '#{date}'::TIMESTAMP WITH TIME ZONE) + interval '1 day' - interval '1 second')"

    withdrawn_transactions.read(
      "SELECT (SUM(dt.amount) - SUM(wt.amount)) * -1 as result from withdrawn_transactions wt
        LEFT JOIN deposit_transactions dt on dt.user_public_id = wt.user_public_id AND #{dt_query}
      WHERE #{query}
      HAVING(SUM(dt.amount) - SUM(wt.amount) < 0)
      "
    )&.map&.first&.dig(:result)
  end
end
