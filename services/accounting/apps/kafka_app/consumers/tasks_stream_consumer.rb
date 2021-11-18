class TasksStreamConsumer < Karafka::BaseConsumer
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      data = message['data']
      case message['event_name']
      when 'Tasks.Created', 'Tasks.Updated'
        repo.create_or_update_by_public_id(data&.dig('public_id'), data)
      end
    end
  end

  def repo
    @_repo ||= TaskRepository.new
  end
end
