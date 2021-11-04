module Auth
  module Controllers
    module OauthSession
      class Destroy
        include Auth::Action

        def call(params={})
          session[:user] = nil
          redirect_to routes.login_path
        end
      end
    end
  end
end
