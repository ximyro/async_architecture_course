class DepositTransactionsStreamConsumer < Karafka::BaseConsumer
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      case message['event_name']
      when 'Billing.DepositTransactionCreated'
        case message['event_version']
        when 'v1'
          repo.create_or_update(message['data'], message['event_time'])
        else
          KafkaApp::Application.logger.error "unsupported message: #{message}"
        end
      end
    end
  end

  def repo
    @_repo ||= DepositTransactionRepository.new
  end
end
