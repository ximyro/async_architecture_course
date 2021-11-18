module Events
  class DailyManagementStatisticsCalculated < Base
    attribute :date, Core::Types::String
    attribute :most_expensive_task_cost, Core::Types::String
    attribute :most_expensive_task_public_id, Core::Types::String
    attribute :employee_with_debt, Core::Types::Int
    attribute :earned, Core::Types::String

    def event_version
      "v1"
    end

    def event_name
      'Analytics.DailyManagementStatisticsCalculated'
    end
  end
end
