class TasksStreamConsumer < Karafka::BaseConsumer
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      data = message['data']
      case message['event_name']
      when 'Tasks.Created', 'Tasks.Updated'
        case message['event_version']
        when 'v1'
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
        when 'v2'
          valid_event?
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
        end
      end
    end
  end

  def valid_event?
    true
  end

  def repo
    @_repo ||= TaskRepository.new
  end
end
