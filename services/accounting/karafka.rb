require_relative 'config/environment'
require_relative 'apps/kafka_app/application'
Hanami.boot
KafkaApp::Application.boot!