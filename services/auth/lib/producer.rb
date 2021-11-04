class Producer
  class << self
    def call(data, topic)
      Rails.logger.info("Sending #{data} to the #{topic}")
    end
  end
end
