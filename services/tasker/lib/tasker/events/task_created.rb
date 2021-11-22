module Events
  class TaskCreated < Base
    attribute :public_id, Core::Types::String
    attribute :title, Core::Types::String
    attribute :jira_id, Core::Types::String
    attribute :description, Core::Types::String
    attribute :assigned_user_id, Core::Types::String
    attribute :status, Core::Types::String

    def event_name
      "Tasks.Created"
    end

    def event_version
      "v2"
    end
  end
end
