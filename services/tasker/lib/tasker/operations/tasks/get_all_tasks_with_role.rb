# frozen_string_literal: true

require_relative "base"

module Operations
  module Tasks
    class GetAllTasksWithRole < Base
      def call(user)
        tasks = []
        if user.role != "manager"
          tasks = task_repo.all_with_user(user)
        else
          tasks = task_repo.all
        end
        Success(tasks)
      end
    end
  end
end
