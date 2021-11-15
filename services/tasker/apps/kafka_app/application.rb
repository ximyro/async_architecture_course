require_relative './consumers/users_stream_consumer'

Karafka::Loader.load(Karafka::App.root)

module KafkaApp
  class Application < Karafka::App
    setup do |config|
      config.kafka.seed_brokers = %w[kafka://kafka:9092]
      config.client_id = 'tasker'
      config.backend = :inline
      config.batch_fetching = true
      # Uncomment this for Rails app integration
      config.logger = Logger.new($stdout)
    end

    after_init do |config|
      # Put here all the things you want to do after the Karafka framework
      # initialization
    end


    # Comment out this part if you are not using instrumentation and/or you are not
    # interested in logging events for certain environments. Since instrumentation
    # notifications add extra boilerplate, if you want to achieve max performance,
    # listen to only what you really need for given environment.
    Karafka.monitor.subscribe(Karafka::Instrumentation::Listener)

    consumer_groups.draw do
      topic :'users-stream' do
        consumer UsersStreamConsumer
      end

      # consumer_group :bigger_group do
      #   topic :test do
      #     consumer TestConsumer
      #   end
      #
      #   topic :test2 do
      #     consumer Test2Consumer
      #   end
      # end
    end
  end
end