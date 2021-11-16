module Events
  class TaskBegun < Base
    attribute :public_id, Core::Types::String

    def event_name
      "Tasks.Begun"
    end

    def event_version
      "v1"
    end
  end
end
