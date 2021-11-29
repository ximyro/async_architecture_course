module Api
  module Views
    module Tasks
      class CreateCosts
        include Api::View
        include Dry::Monads::Result::Mixin

        format :json

        def render
          case @result
          when Success
            raw JSON.generate(
              status: 'ok',
              result: result
            )
          when Failure
            raw JSON.generate(
              message: 'something goes wrong'
            )
          end
        end
      end
    end
  end
end
