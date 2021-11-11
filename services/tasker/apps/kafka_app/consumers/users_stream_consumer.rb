class UsersStreamConsumer < Karafka::BaseConsumer
  #def process
  #  byebug
  #end

  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the users-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      case message['event_name']
      when 'Users.Created'
        create_or_update_user(message['data'])
      when 'Users.Updated'
        update_user(message['data'])
      end
    end
  end

  def create_or_update_user(data)
    user = repo.find_by_public_id(data['public_id'])
    if user
      repo.update(
        user.id,
        role: data['role'],
        email: data['email'],
        full_name: data['full_name']
      )
    else
      repo.create(
        role: data['role'],
        email: data['email'],
        full_name: data['full_name'],
        public_id: data['public_id']
      )
    end
  rescue => e
    KafkaApp::Application.logger.error "can't create or update user: #{data}: #{e}"
  end

  def update_user(data)
    user = repo.find_by_public_id(data['public_id'])
    return nil unless user

    repo.update(
      user.id,
      role: data['role'],
      email: data['email'],
      full_name: data['full_name']
    )
  end

  def repo
    @_repo ||= UserRepository.new
  end
end
