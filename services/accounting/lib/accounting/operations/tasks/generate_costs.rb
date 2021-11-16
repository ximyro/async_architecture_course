# frozen_string_literal: true

module Operations
  module Tasks
    class GenerateCosts < ::Libs::Operation
      def call(public_id)
        task = repo.transaction do
          task = repo.find_or_create_by_public_id(public_id)
          repo.update_costs(task.id, generate_assignment_fee, generate_amount)
        end

        Success(task)
      end

      private

      # Currency - USD
      def generate_assignment_fee
        rand(1..100)
      end

      def generate_amount
        rand(1..100)
      end

      def repo
        @_repo ||= TaskRepository.new
      end
    end
  end
end
