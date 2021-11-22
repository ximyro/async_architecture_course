module Events
  class TaskUpdated < TaskCreated
    def event_name
      "Tasks.Updated"
    end
  end
end
