module Auth
  module Controllers
    module OauthSession
      class Create
        include Auth::Action
        include Dry::Monads::Result::Mixin

        def call(params)
          result = operation.call(
            provider: params[:provider].to_s,
            payload: request.env['omniauth.auth']
          )

          case result
          when Success
            user = result.value!
            session[:user_id] = user.id
            redirect_to '/'
          when Failure
            redirect_to routes.login_path
          end
        end

        private

        def operation
          @_operation ||= Operations::Users::CreateByOauth.new
        end
      end
    end
  end
end
