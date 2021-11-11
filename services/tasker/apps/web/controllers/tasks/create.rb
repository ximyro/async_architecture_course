module Web
  module Controllers
    module Tasks
      class Create
        include Web::Action
        include AuthorizationHelper

        def call(params)
          task_params = params[:task]
          task_params[:user_id] = random_user_id
          task = task_repo.create(params[:task])
          event_repo.task_created(task)

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
