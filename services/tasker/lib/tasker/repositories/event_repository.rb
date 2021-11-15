class EventRepository
  def task_created(task)
    event = {
      event_name: "Tasks.Created",
      data: {
        public_id: task.id, # TODO(@ximyro): replace it with public id
        title: task.title,
        description: task.description,
        assigned_user_id: task.user_id,
        status: task.status
      }
    }
    producer.call(event.to_json, 'tasks-stream')
  end

  def task_assigned(task)
    event = {
      event_name: "Tasks.Assigned",
      data: {
        public_id: task.id, # TODO(@ximyro): replace it with public id
        title: task.title,
        description: task.description,
        assigned_user_id: task.user_id,
        status: task.status
      }
    }
    producer.call(event.to_json, 'tasks-stream')
  end

  def task_completed(task)
    event = {
      event_name: "Tasks.Completed",
      data: {
        public_id: task.id, # TODO(@ximyro): replace it with public id
        title: task.title,
        description: task.description,
        assigned_user_id: task.user_id,
        status: task.status
      }
    }
    producer.call(event.to_json, 'tasks-stream')
  end

  def producer
    @_producer ||= Producer
  end
end
