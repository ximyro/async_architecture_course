require_relative 'base'

module Events
  class BalanceAccrued < Base
    attribute :task_public_id, Core::Types::String
    attribute :user_public_id, Core::Types::String
    attribute :reason, Core::Types::String
    attribute :description, Core::Types::String

    def event_name
      "Users.BalanceAccrued"
    end

    def event_version
      "v1"
    end
  end
end
