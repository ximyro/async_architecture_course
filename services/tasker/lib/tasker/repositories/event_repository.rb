class EventRepository
  def task_created(task)
    event = {
      event_name: "Tasks.Created",
      event_version: "v1",
      data: {
        public_id: task.id, # TODO(@ximyro): replace it with public id
        title: task.title,
        description: task.description,
        assigned_user_id: task.user_id,
        status: task.status
      }
    }
    event = extend_event(event)
    send_event(event, 'tasks-stream')
  end

  def task_updated(task)
    event = {
      event_name: "Tasks.Updated",
      event_version: "v1",
      data: {
        public_id: task.id, # TODO(@ximyro): replace it with public id
        title: task.title,
        description: task.description,
        assigned_user_id: task.user_id,
        status: task.status
      }
    }
    event = extend_event(event)
    send_event(event, 'tasks-stream')
  end

  def task_assigned(task)
    event = {
      event_name: "Tasks.Assigned",
      event_version: "v1",
      data: {
        public_id: task.id,
        assigned_user_id: task.user_id,
      }
    }
    event = extend_event(event)
    send_event(event, 'tasks')
  end

  def task_completed(task, user_id)
    event = {
      event_name: "Tasks.Completed",
      event_version: "v1",
      data: {
        public_id: task.id, # TODO(@ximyro): replace it with public id
        completed_by_user_id: user_id,
      }
    }
    event = extend_event(event)
    send_event(event, 'tasks')
  end

  def send_event(event, topic)
    SchemaRegistry.valid_event?(
      event[:event_name],
      event[:event_version],
      event
    )
    producer.call(event.to_json, topic)
  rescue JSON::Schema::ValidationError => e
    Hanami.logger.error "Can't send the event: #{event}, error: #{e.inspect}"
  end

  def extend_event(event)
    event.merge!(
      {
        event_time: Time.now.to_i.to_s,
        producer: "tasker",
        event_id: SecureRandom.uuid
      }
    )
  end

  def producer
    @_producer ||= Producer
  end
end
