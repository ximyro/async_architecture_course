class Producer
  class << self
    def call(data, topic)
      Rails.logger.info("Sending #{data} to the #{topic}")
      kafka_client.produce_sync(topic: topic, payload: data)
    end

    private

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
