# frozen_string_literal: true
module Operations
  module Transactions
    class ApplyDeposit < ::Libs::Operation
      def call(public_id:, completed_by_user_id:, reason:)
        task = repo.transaction do
          task = repo.find_or_create_by_public_id(public_id)

          if task.amount <= 0
            # I don't know now what do we need to do here
            return Failure(:amount_is_not_set)
          end

          user = users_repo.find_or_create_by_public_id(
            completed_by_user_id,
            public_id: completed_by_user_id
          )

          deplosit_reasaon = "Начисление за выполнение задачи: #{reason}"
          transactions_repo.create(
            task_id: task.id,
            user_id: user.id,
            amount: task.amount,
            reason: deplosit_reasaon
          )
          users_repo.accure_balance(user.id, task.amount)
        end

        Producer.call(
          Events::DepositTransactionApplied.new(
            task_public_id: public_id,
            user_public_id: completed_by_user_id,
            amount: BigDecimal(task.amount).to_s('F'),
            reason: deplosit_reasaon
          ),
          'deposit-transactions-stream'
        )

        Success(task)
      end

      def repo
        @_repo ||= TaskRepository.new
      end

      def transactions_repo
        @_transactions_repo ||= DepositTransactionRepository.new
      end

      def users_repo
        @users_repo ||= UserRepository.new
      end
    end
  end
end
