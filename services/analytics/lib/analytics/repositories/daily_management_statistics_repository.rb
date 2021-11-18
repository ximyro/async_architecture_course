class DailyManagementStatisticsRepository < Hanami::Repository
  def from_the_day(date)
    daily_management_statistics.where(date: date).one
  end

  def sorted_by_date
    daily_management_statistics.order { date.desc }
  end
end
