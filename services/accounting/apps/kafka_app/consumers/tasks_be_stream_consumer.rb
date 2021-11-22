class TasksBEStreamConsumer < Karafka::BaseConsumer
  include Dry::Monads::Result::Mixin
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      data = message['data']
      public_id = data&.dig('public_id')
      result = case message['event_name']
                when 'Tasks.Assigned'
                  case message['event_version']
                  when 'v1'
                    Operations::Transactions::ApplyWithdraw.new.call(
                      public_id: public_id,
                      assigned_user_id: data&.dig('assigned_user_id'),
                      reason: data&.dig('title') || "Task #{public_id}"
                    )
                  when 'v2'
                    unless valid_event?(data)
                      KafkaApp::Application.logger.error "invalid event: #{data}"
                      return
                    end
                    Operations::Transactions::ApplyWithdraw.new.call(
                      public_id: public_id,
                      assigned_user_id: data&.dig('assigned_user_id'),
                      reason: data&.dig('title') || "Task #{public_id}"
                    )
                  else
                    KafkaApp::Application.logger.error "unsupported version #{message['event_version']} of message #{message}"
                  end
                when 'Tasks.Completed'
                  case message['event_version']
                  when 'v1'
                    Operations::Transactions::ApplyDeposit.new.call(
                      public_id: public_id,
                      completed_by_user_id: data&.dig('completed_by_user_id'),
                      reason: data&.dig('title') || "Task #{public_id}"
                    )
                  when 'v2'
                    unless valid_event?(data)
                      KafkaApp::Application.logger.error "invalid event: #{data}"
                      return
                    end
                    Operations::Transactions::ApplyDeposit.new.call(
                      public_id: public_id,
                      completed_by_user_id: data&.dig('completed_by_user_id'),
                      reason: data&.dig('title') || "Task #{public_id}"
                    )
                  else
                    KafkaApp::Application.logger.error "unsupported version #{message['event_version']} of message #{message}"
                  end
                else
                  KafkaApp::Application.logger.error "unsupported message: #{message}"
               end

      if result == Failure
        KafkaApp::Application.logger.error "can't handle message: #{message}, error: #{result.inspect}"
      end
    end
  end

  def valid_event?(data)
    title = data&.dig('title')
    return true unless title

    !(title.include?('[') | title.include?(']'))
  end
end
