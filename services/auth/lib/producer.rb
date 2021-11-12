class Producer
  class << self
    def call(data, topic)
      Rails.logger.info("Sending #{data} to the #{topic}")
      event = extend_event(data)
      send_event(event, topic)
    end

    private

    def extend_event(event)
      event.merge!(
        {
          event_time: Time.now.to_i.to_s,
          producer: "auth",
          event_id: SecureRandom.uuid
        }
      )
    end

    def send_event(event, topic)
      SchemaRegistry.valid_event?(
        event[:event_name],
        event[:event_version],
        event
      )
      kafka_client.produce_sync(topic: topic, payload: event.to_json)
    rescue JSON::Schema::ValidationError => e
      Rails.logger.error "Can't send the event: #{event}, error: #{e.inspect}"
    end

    def kafka_client
      return @_kafka_client if @_kafka_client.present?

      @_kafka_client = WaterDrop::Producer.new

      @_kafka_client.setup do |config|
        config.deliver = true
        config.kafka = {
          'bootstrap.servers': 'kafka:9092',
          'request.required.acks': 1
        }
      end
      @_kafka_client
    end
  end
end
