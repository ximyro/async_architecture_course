# frozen_string_literal: true

module Operations
  module Tasks
    class Withdraw < ::Libs::Operation
      def call(public_id:, assigned_user_id:)
        task = repo.transaction do
          task = repo.find_or_create_by_public_id(public_id)
          Failure(:assignment_fee_is_not_set) if task.assignment_fee <= 0 # I don't know now what do we need to do here

          user = users_repo.find_or_create_by_public_id(assigned_user_id, {
            public_id: assigned_user_id
          })
          transactions_repo.create(
            task_id: task.id,
            user_id: user.id,
            amount: task.assignment_fee
          )
        end

        Success(task)
      end

      def repo
        @_repo ||= TaskRepository.new
      end

      def transactions_repo
        @_transactions_repo = WithdrawTransactionRepository.new
      end

      def users_repo
        @_transactions_repo = UserRepository.new
      end
    end
  end
end
