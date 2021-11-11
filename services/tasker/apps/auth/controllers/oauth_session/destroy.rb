module Auth
  module Controllers
    module OauthSession
      class Destroy
        include Auth::Action

        def call(_params = {})
          session[:user_id] = nil
          redirect_to '/auth/signin'
        end
      end
    end
  end
end
