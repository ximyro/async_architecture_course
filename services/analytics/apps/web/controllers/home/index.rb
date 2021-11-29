module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include AuthorizationHelper
        expose :title
        expose :current_user
        expose :daily_statistics
        expose :tasks

        def call(_params)
          @title = "Accounting"
          if !current_user.present? || current_user&.role != "manager"
            redirect_to '/auth/signin'
          end

          @daily_statistics = daily_statistics_repo.sorted_by_date.to_a
          @tasks = tasks_repo.with_public_ids(@daily_statistics.map(&:most_expensive_task_public_id)).to_a
          @current_user = current_user
        end

        def daily_statistics_repo
          @_daily_statistics_repo ||= DailyManagementStatisticsRepository.new
        end

        def tasks_repo
          @_tasks_repo ||= TaskRepository.new
        end
      end
    end
  end
end
