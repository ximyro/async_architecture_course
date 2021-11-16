class Producer
  class << self
    def call(event, topic)
      event_data = event.serialize
      SchemaRegistry.valid_event?(
        event_data[:event_name],
        event_data[:event_version],
        event_data
      )

      Hanami.logger.info "Sending event: #{event_data}, with topic: #{topic}"
      WaterDrop::SyncProducer.call(event.serialize.to_json, topic: topic)
    rescue JSON::Schema::ValidationError => e
      Hanami.logger.error "Can't send the event: #{event_data}, error: #{e.inspect}"
    end
  end
end
