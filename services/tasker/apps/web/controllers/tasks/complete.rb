module Web
  module Controllers
    module Tasks
      class Complete
        include Web::Action
        include AuthorizationHelper

        def call(params)
          task = task_repo.update(params[:id], status: 'completed')
          task = task_repo.find_with_user(task.id)
          event = task.to_h.merge(completed_by_user_id: task.user.public_id, assigned_user_id: task.user.public_id)
          Producer.call(Events::TaskUpdated.new(event.to_h), 'tasks-stream')
          Producer.call(Events::MilletInBowl.new(event.to_h), 'tasks')

          redirect_to '/'
        end

        def task_repo
          @_task_repo ||= TaskRepository.new
        end
      end
    end
  end
end
