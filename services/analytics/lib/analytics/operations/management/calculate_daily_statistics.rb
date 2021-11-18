# frozen_string_literal: true

module Operations
  module Management
    class CalculateDailyStatistics < ::Libs::Operation
      def call(date)
        date = Time.parse(date)
        deposit_transaction = deposit_transactions_repo.with_max_amount_per_day(date)
        users_with_dept = withdrawn_transactions_repo.find_users_count_with_debt(date)
        management_earn = withdrawn_transactions_repo.find_management_earn(date)
        statistics_repo.create(
          date: date,
          most_expensive_task_cost: deposit_transaction&.amount || 0,
          most_expensive_task_public_id: deposit_transaction&.task_public_id,
          employee_with_debt: users_with_dept || 0,
          earned: management_earn || 0
        )

        Producer.call(
          Events::DailyManagementStatisticsCalculated.new(
            date: date,
            most_expensive_task_cost: deposit_transaction&.amount&.to_s || "0",
            most_expensive_task_public_id: deposit_transaction&.task_public_id,
            employee_with_debt: users_with_dept&.to_s || "0",
            earned: management_earn&.to_s || "0"
          ),
          'analytics-stream'
        )
      end

      def deposit_transactions_repo
        @_repo ||= DepositTransactionRepository
      end

      def withdrawn_transactions_repo
        @_withdrawn_transactions_repo ||= WithdrawnTransactionRepository.new
      end

      def statistics_repo
        @_statistics_repo ||= DailyDepositTransactionRepository.new
      end
    end
  end
end
