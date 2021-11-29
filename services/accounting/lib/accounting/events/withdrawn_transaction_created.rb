require_relative 'base'

module Events
  class WithdrawnTransactionCreated < Base
    attribute :task_public_id, Core::Types::String
    attribute :user_public_id, Core::Types::String
    attribute :amount, Core::Types::String
    attribute :reason, Core::Types::String
    attribute :description, Core::Types::String

    def event_name
      "Billing.WithdrawnTransactionCreated"
    end

    def event_version
      "v1"
    end
  end
end
