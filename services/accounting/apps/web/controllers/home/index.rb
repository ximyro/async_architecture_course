module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include AuthorizationHelper
        expose :title
        expose :current_user

        def call(params)
          @title = "Home(accounting)"
          @current_user = current_user
        end
      end
    end
  end
end
