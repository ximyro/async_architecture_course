class UsersStreamConsumer < Karafka::BaseConsumer
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the users-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      data = message['data']
      case message['event_name']
      when 'Users.Created', 'Users.Updated'
        case message['event_version']
        when 'v1'
          repo.create_or_update_by_public_id(data&.dig('public_id'), data)
        else
          Hanami.logger.error "unsupported version: #{message['event_version']} of message: #{message}"
        end
      end
    rescue => e
      KafkaApp::Application.logger.error "can't create or update user: #{data}: #{e}"
    end
  end

  def repo
    @_repo ||= UserRepository.new
  end
end
