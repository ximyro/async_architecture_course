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
            @date = users_repo.last_date_with_statistics(current_user.id)
            if date.present?
              @transactions = []
              @transactions += daily_deposit_transactions_repo.find_with_user_and_date(current_user.id, @date).to_a
              @transactions += daily_withdraw_transactions_repo.find_with_user_and_date(current_user.id, @date).to_a
              @transactions += deposit_transactions_repo.find_with_user_and_date(current_user.id, @date).to_a
              @transactions += withdraw_transactions_repo.find_with_user_and_date(current_user.id, @date).to_a

              @transactions.sort_by!(&:created_at)
            end
          end

          @current_user = current_user
        end

        def daily_statistics_repo
          @_daily_statistics_repo ||= DailyManagementStatisticsRepository.new
        end

        def daily_deposit_transactions_repo
          @_daily_deposit_transactions_repo ||= DailyDepositTransactionRepository.new
        end

        def deposit_transactions_repo
          @_deposit_transactions_repo ||= DepositTransactionRepository.new
        end

        def withdraw_transactions_repo
          @_withdraw_transactions_repo ||= WithdrawTransactionRepository.new
        end

        def daily_withdraw_transactions_repo
          @_daily_withdraw_transactions_repo ||= DailyWithdrawTransactionRepository.new
        end

        def users_repo
          @_users_repo ||= UserRepository.new
        end
      end
    end
  end
end
