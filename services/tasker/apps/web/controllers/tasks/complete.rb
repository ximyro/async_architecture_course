module Web
  module Controllers
    module Tasks
      class Complete
        include Web::Action
        include AuthorizationHelper

        def call(params)
          task = task_repo.update(params[:id], status: 'completed')
          event_repo.task_completed(task)
          redirect_to '/'
        end

        def task_repo
          @_task_repo ||= TaskRepository.new
        end

        def event_repo
          @_event_repo ||= EventRepository.new
        end
      end
    end
  end
end
