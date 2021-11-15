class Producer
  class << self
    def call(data, topic)
      setup
      Hanami.logger.info "Sending event: #{data}, with topic: #{topic}"
      WaterDrop::SyncProducer.call(data, topic: topic)
    end

    private

    def setup
      return @setuped if @setuped.present?

      WaterDrop.setup do |config|
        config.deliver = true
        config.kafka.seed_brokers = ['kafka://kafka:9092']
      end
      @setuped = true
    end
  end
end
