# frozen_string_literal: true
module Operations
  module Tasks
    class Deposit < ::Libs::Operation
      def call(public_id:, completed_by_user_id:)
        task = repo.transaction do
          task = repo.find_or_create_by_public_id(public_id)
          Failure(:amount_is_not_set) if task.amount <= 0 # I don't know now what do we need to do here

          user = users_repo.find_or_create_by_public_id(completed_by_user_id, {
            public_id: completed_by_user_id
          })
          transactions_repo.create(
            task_id: task.id,
            user_id: user.id,
            amount: task.amount
          )
        end

        Success(task)
      end

      def repo
        @_repo ||= TaskRepository.new
      end

      def transactions_repo
        @_transactions_repo = DepositTransactionRepository.new
      end

      def users_repo
        @_transactions_repo = UserRepository.new
      end
    end
  end
end
