class AnalyticsStreamConsumer < Karafka::BaseConsumer
  include Dry::Monads::Result::Mixin
  def consume
    params_batch.each do |message|
      KafkaApp::Application.logger.info "Receive a message #{message} from the analytics-stream"
      if !message['parsed']
        KafkaApp::Application.logger.error "incorrect message #{message}"
        return nil
      end

      result = case message['event_name']
      when 'Analytics.DailyManagementStatisticsCalculated'
        case message['event_version']
        when 'v1'
          data = message['data']
          repo.create(
            date: Time.parse(data['date']),
            earn: BigDecimal(data['earned'])
          )
        else
          Hanami.logger.error "unsupported version #{message['event_version']} of message Analytics.DailyManagementCalculated: #{message}"
        end
      else
        Hanami.logger.error "unsupported message: #{message}"
      end
    end
  end

  def repo
    @_repo ||= DailyManagementStatisticsRepository.new
  end
end