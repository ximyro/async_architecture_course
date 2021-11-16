require "schema_registry/version"
require 'json-schema'

module SchemaRegistry
  class Error < StandardError; end
  # Your code goes here...

  class << self
    def valid_event?(event_name, version, payload)
      path = File.expand_path('..', __dir__)
      schema_path = File.join(
        path,
        'schemas',
        map_event_name_to_path(event_name),
        "#{version}.json",
      )
      schema = File.read(schema_path)
      JSON::Validator.validate!(schema, payload)
    end

    def map_event_name_to_path(event_name)
      case event_name
      when "Tasks.Created"
        "tasks/created"
      when "Tasks.Updated"
        "tasks/updated"
      when "Tasks.Assigned"
        "tasks/assigned"
      when "Tasks.Completed"
        "tasks/completed"
      when "Tasks.Begun"
        "tasks/begun"
      when "Users.Created"
        "users/created"
      when "Users.Deleted"
        "users/deleted"
      when "Users.RoleChanged"
        "users/role_changed"
      when "Users.Updated"
        "users/updated"
      else
        raise "Unsupported event: #{event_name}"
      end
    end
  end
end
