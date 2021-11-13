# frozen_string_literal: true

require_relative "../../repositories/user_repository"

module Operations
  module Users
    class CreateByOauth < ::Libs::Operation
      def call(provider:, payload:)
        user = repo.find_by_auth_identity(provider, auth_identity_params(payload))
        if user.nil?
          user = repo.find_or_create_by_public_id(
            payload['info']['public_id'],
            user_params(payload)
          )

          yield persist(provider, user, payload)
        end

        Success(user)
      end

      private

      def persist(provider, user, payload)
        Success(
          repo.create_with_identity(
            provider,
            user,
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
        @_repo ||= UserRepository.new
      end
    end
  end
end
