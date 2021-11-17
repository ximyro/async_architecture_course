module Events
  class TaskAssigned < Base
    attribute :public_id, Core::Types::String
    attribute :assigned_user_id, Core::Types::String
    attribute :title, Core::Types::String
    attribute :description, Core::Types::String

    def event_name
      "Tasks.Assigned"
    end

    def event_version
      "v1"
    end
  end
end
