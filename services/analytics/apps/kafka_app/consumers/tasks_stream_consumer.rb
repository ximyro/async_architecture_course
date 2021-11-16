class TasksBEStreamConsumer < Karafka::BaseConsumer
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end
    end
  end
end
