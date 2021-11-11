require_relative '../../helpers/authorization_helper'
module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include AuthorizationHelper
        expose :tasks
        expose :title
        expose :current_user

        def call(_params)
          @title = 'Tasks'

          if current_user.role == "manager"
            @tasks = task_repo.find_with_users
          else
            @tasks = task_repo.find_user_tasks(current_user)
          end
        end

        def task_repo
          @_task_repo ||= TaskRepository.new
        end
      end
    end
  end
end
