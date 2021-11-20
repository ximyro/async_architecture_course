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
      when 'Tasks.Created'
        case message['event_version']
        when 'v1'
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
          generate_costs_operation.call(
            public_id: data['public_id'],
            assigned_user_id: data['assigned_user_id'],
            reason: data['title']
          )
        else
          Hanami.logger.error "unsupported version #{message['event_version']} for message: #{message}"
        end

      when 'Tasks.Updated'
        case message['event_version']
        when 'v1'
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
        else
          Hanami.logger.error "unsupported version #{message['event_version']} for message: #{message}"
        end
      end
    end
  end

  def repo
    @_repo ||= TaskRepository.new
  end

  def generate_costs_operation
    @_generate_costs_operation ||=  Operations::Tasks::GenerateCosts.new
  end
end
