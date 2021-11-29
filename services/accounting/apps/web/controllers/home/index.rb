module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include AuthorizationHelper
        expose :title
        expose :current_user
        expose :daily_statistics
        expose :balance
        expose :transactions
        expose :date

        def call(params)
          @title = "Accounting"
          unless current_user.present?
            redirect_to '/auth/signin'
          end

          if current_user.role == 'manager'
            @daily_statistics = daily_statistics_repo.last_ordered_by_date
          else
            @balance = current_user.balance
            @transactions = transactions_repo.for_period(
              current_user.id,
              params[:started_at],
              params[:eneded_at]
            )
          end

          @current_user = current_user
        end

        def daily_statistics_repo
          @_daily_statistics_repo ||= DailyManagementStatisticsRepository.new
        end

        def transactions_repo
          @_transaction_repo ||= TransactionRepository.new
        end
      end
    end
  end
end
