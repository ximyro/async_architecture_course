class TasksBEStreamConsumer < Karafka::BaseConsumer
  include Dry::Monads::Result::Mixin
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      data = message['data']
      public_id = data&.dig('public_id')
      result = case message['event_name']
                when 'Tasks.Assigned'
                  Operations::Tasks::Withdraw.new.call(
                    public_id: public_id,
                    assigned_user_id: data&.dig('assigned_user_id'),
                    reason: data&.dig('title'),
                    description: data&.dig('description')
                  )
                when 'Tasks.Completed'
                  Operations::Tasks::Deposit.new.call(
                    public_id: public_id,
                    completed_by_user_id: data&.dig('completed_by_user_id'),
                    reason: data&.dig('title'),
                    description: data&.dig('description')
                  )
                else
                  Hanami.logger.error "unsupported message: #{message}"
               end

      if result == Failure
        Hanami.logger.error "can't handle message: #{message}, error: #{result.inspect}"
      end
    end
  end
end
