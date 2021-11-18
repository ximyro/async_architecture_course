class CostCreator
  class << self
    def call(task)
      result = HTTP.post("http://accounting:2300/api/tasks/create_costs", json: { task: task })
      Hanami.logger.info "Result body: #{result.body.to_s}, other information: #{result.inspect}"
      result
    end
  end
end
