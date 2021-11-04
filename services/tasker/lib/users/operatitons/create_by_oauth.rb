# frozen_string_literal: true

require_relative "../../tasker/repositories/user_repository"

module Users
  module Operations
    class CreateByOauth < ::Libs::Operation
      def call(provider:, payload:)
        user = repo.find_by_auth_identity(provider, auth_identity_params(payload))
        if user.nil?
          user = yield persist(provider, payload)
        end

        Success(user)
      end

      private

      def persist(provider, payload)
        Success(
          repo.create_with_identity(
            Core::Types::AuthIdentityProvider(provider),
            user_params(payload),
            auth_identity_params(payload)
          )
        )
      rescue Dry::Types::ConstraintError
        Failure(:invalid_provider)
      end

      def user_params(payload)
        {
          public_id: payload['info']['public_id'],
          full_name: payload['info']['full_name'],
          email: payload['info']['email'],
          role: payload['info']['role']
        }
      end

      def auth_identity_params(payload)
        {
          uid: payload['uid'],
          token: payload['credentials']['token'],
          login: payload['info']['email']
        }
      end

      def repo
        @_repo ||= nil
      end
    end
  end
end
