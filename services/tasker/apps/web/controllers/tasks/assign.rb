module Web
  module Controllers
    module Tasks
      class Assign
        include Web::Action
        include AuthorizationHelper
        include Dry::Monads::Result::Mixin

        def call(_params)
          tasks = task_repo.all_opened
          tasks.each do |task|
            result = operation.call(task)
            if result == Failure
              Hanami.logger.error "can't assign task with id #{task.id}"
            end
          end
          redirect_to '/'
        end

        def operation
          @_operation ||= Operations::Tasks::Assign.new
        end

        def task_repo
          @_task_repo ||= TaskRepository.new
        end
      end
    end
  end
end
