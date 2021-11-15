module Web
  module Controllers
    module Tasks
      class New
        include Web::Action
        include AuthorizationHelper
        expose :title
        expose :current_user

        def call(_params)
          @title = 'New Task'
        end
      end
    end
  end
end
