module Web
  module Controllers
    module Tasks
      class Assign
        include Web::Action
        include AuthorizationHelper

        def call(_params)
          tasks = task_repo.all_opened_tasks
          tasks.each do |task|
            task_repo.update(task.id, user_id: random_user_id)
            event_repo.task_assigned(task)
            event_repo.task_updated(task)
          end
          redirect_to '/'
        end

        def task_repo
          @_task_repo ||= TaskRepository.new
        end

        def user_repo
          @_user_repo ||= UserRepository.new
        end

        def random_user_id
          user_repo.get_random_user&.id
        end

        def event_repo
          @_event_repo ||= EventRepository.new
        end
      end
    end
  end
end
