require_relative 'base'

module Events
  class BillingCycleClosed < Base
    attribute :date, Core::Types::String
    def event_name
      "Billing.BillingCycleClosed"
    end

    def event_version
      "v1"
    end
  end
end
