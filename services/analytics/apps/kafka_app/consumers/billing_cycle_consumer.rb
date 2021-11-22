class BillingCycleConsumer < Karafka::BaseConsumer
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the tasks-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      case message['event_name']
      when 'Billing.BillingCycleClosed'
        case message['event_version']
        when 'v1'
          operation.call(message.dig('data', 'date'))
        else
          KafkaApp::Application.logger.error "unsupported message: #{message}"
        end
      end
    end
  end

  def operation
    @_operation ||= Operations::Management::CalculateDailyStatistics.new
  end
end
