module Events
  class Base < Dry::Struct
    constructor_type :schema

    def serialize
      {
        event_time: Time.now.to_i.to_s,
        producer: "accounting",
        event_id: SecureRandom.uuid,
        event_name: event_name,
        event_version: event_version,
        data: to_h
      }
    end

    def event_name
      raise NotImplementedError
    end

    def event_version
      raise NotImplementedError
    end
  end
end
