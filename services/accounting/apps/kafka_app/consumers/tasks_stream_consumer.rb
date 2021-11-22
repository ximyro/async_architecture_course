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
          generate_costs_operation.call(data['public_id'])
        when 'v2'
          valid_event?(data)
          repo.create_or_update_by_puc_id(data&.dig('public_id'), data)
          generate_costs_operation.call(blidata['public_id'])
        else
          Hanami.logger.error "unsupported version #{message['event_version']} for message: #{message}"
        end

      when 'Tasks.Updated'
        case message['event_version']
        when 'v1'
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
        when 'v2'
          valid_event?(data)
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
        else
          Hanami.logger.error "unsupported version #{message['event_version']} for message: #{message}"
        end
      end
    end
  end

  def valid_event?(_data)
    true
  end

  def repo
    @_repo ||= TaskRepository.new
  end

  def generate_costs_operation
    @_generate_costs_operation ||= Operations::Tasks::GenerateCosts.new
  end
end
