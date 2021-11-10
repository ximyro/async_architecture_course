module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "doorkeeper"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "http://auth:3000/oauth/authorize",
        :authorize_url => "http://localhost:8080/oauth/authorize"
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['public_id'] }

      info do
        {
          :email => raw_info['email'],
          :full_name => raw_info["full_name"],
          :role => raw_info["role"],
          :public_id => raw_info["public_id"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/admin/users/me').parsed
      end
    end
  end
end
