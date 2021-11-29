module Events
  class TaskCompleted < Base
    attribute :public_id, Core::Types::String
    attribute :completed_by_user_id, Core::Types::String
    attribute :title, Core::Types::String
    attribute :description, Core::Types::String

    def event_name
      "Tasks.Completed"
    end

    def event_version
      "v1"
    end
  end
end
