# frozen_string_literal: true
require_relative "base"
require_relative "../../repositories/user_repository"
require_relative "../../repositories/event_repository"

module Operations
  module Tasks
    class Assign < Base
      def call(task)
        task_repo.update(task.id, user_id: random_user_id)
        event_repo.task_assigned(task)
        event_repo.task_updated(task)
      end

      def user_repo
        @_user_repo ||= UserRepository.new
      end

      def random_user_id
        user_repo.random_user&.id
      end

      def event_repo
        @_event_repo ||= EventRepository.new
      end

      private :random_user_id, :user_repo
    end
  end
end
