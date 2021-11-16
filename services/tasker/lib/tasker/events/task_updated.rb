module Events
  class TaskUpdated < TaskCreated
    def event_name
      "Tasks.Updated"
    end

    def event_version
      "v1"
    end
  end
end
