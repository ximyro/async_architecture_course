class Producer
  class << self
    def call(data, topic)
      Rails.logger.info("Sending #{data} to the #{topic}")
      kafka_client.produce_sync(topic: topic, payload: data)
    end

    private

    def kafka_client
      return @_kafak_client if @_kafak_client.present?

      @_kafak_client = WaterDrop::Producer.new

      @_kafak_client.setup do |config|
        config.deliver = true
        config.kafka = {
          'bootstrap.servers': 'kafka:9092',
          'request.required.acks': 1
        }
      end
      @_kafak_client
    end
  end
end
