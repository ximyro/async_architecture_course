require_relative 'config/environment'
require_relative 'apps/kafka_app/application'

KafkaApp::Application.boot!