require_relative '../../helpers/authorization_helper'
module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include AuthorizationHelper
        include Dry::Monads::Result::Mixin
        expose :tasks
        expose :title
        expose :current_user

        def call(_params)
          @title = 'Tasks'
          result = operation.call(current_user)
          case result
          when Success
            @tasks = result.value!
          when Failure
            redirect_to routes.login_path
          end
        end

        def operation
          @_operation ||= Operations::Tasks::GetAllTasksWithRole.new
        end
      end
    end
  end
end
