require_relative 'base'

module Events
  class BalanceWithDrawn < Base
    attribute :task_public_id, Core::Types::String
    attribute :user_public_id, Core::Types::String
    attribute :reason, Core::Types::String
    attribute :description, Core::Types::String

    def event_name
      "Users.BalanceWithdrawn"
    end

    def event_version
      "v1"
    end
  end
end
