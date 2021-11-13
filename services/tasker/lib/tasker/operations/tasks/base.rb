# frozen_string_literal: true

require_relative "../../repositories/task_repository"

module Operations
  module Tasks
    class Base < ::Libs::Operation
      def task_repo
        @_task_repo ||= TaskRepository.new
      end

      private :task_repo
    end
  end
end
