module Web
  module Controllers
    module Tasks
      class Create
        include Web::Action
        include AuthorizationHelper

        def call(params)
          task_params = params[:task]
          task = task_repo.transaction do
            task = task_repo.create(task_params)
            task = task_repo.random_assinge(task.id)
          end
          task = task_repo.find_with_user(task.id)
          event = task.to_h.merge(assigned_user_id: task.user.public_id)
          Producer.call(Events::TaskCreated.new(event.to_h), 'tasks-stream')
          Producer.call(Events::TaskBegun.new(event.to_h), 'tasks')
          redirect_to '/'
        end

        def task_repo
          @_task_repo ||= TaskRepository.new
        end
      end
    end
  end
end
