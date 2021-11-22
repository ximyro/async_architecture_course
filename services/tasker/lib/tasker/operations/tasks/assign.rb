# frozen_string_literal: true
require_relative "base"
require_relative "../../repositories/user_repository"

module Operations
  module Tasks
    class Assign < Base
      def call(task)
        task_repo.random_assinge(task.id)
        task = task_repo.find_with_user(task.id)
        event = task.to_h.merge(assigned_user_id: task.user.public_id)
        Producer.call(Events::TaskUpdated.new(event.to_h), 'tasks-stream')
        Producer.call(Events::CagedBird.new(event.to_h), 'tasks')
      end
    end
  end
end
