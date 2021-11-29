module Api
  module Controllers
    module Tasks
      class CreateCosts
        include Api::Action
        include Dry::Monads::Result::Mixin
        accept :json

        def call(params)
          task = params[:task]
          raise "Missing param task" unless task.present?
          @result = operation.call(task[:public_id])

          if @result.is_a?(Success)
            @result = transactions_operation.call(
              public_id: task[:public_id],
              assigned_user_id: task[:assigned_user_id],
              reason: task[:title],
              description: task[:description]
            )
          end
        end

        def operation
          @_operation ||= Operations::Tasks::GenerateCosts.new
        end

        def transactions_operation
          @_transactions_operation ||= Operations::Tasks::Withdraw.new
        end

        private

        def verify_csrf_token?
          false
        end
      end
    end
  end
end
