class DailyManagementStatisticsRepository < Hanami::Repository
  def all_ordered_by_date
    daily_management_statistics.order { date.desc }
  end

  def last_ordered_by_date
    all_ordered_by_date.one
  end
end
