module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        expose :user

        def call(params)
          user = session[:user]
          @user = user.attributes
        end
      end
    end
  end
end
