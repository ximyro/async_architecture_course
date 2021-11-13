class Producer
  class << self
    def call(data, topic)
      Hanami.logger.info "Sending event: #{data}, with topic: #{topic}"
      WaterDrop::SyncProducer.call(data, topic: topic)
    end
  end
end
