module EventsHelper

  def is_today date 
    DateTime.now.day == date.day && DateTime.now.month == date.month && DateTime.now.year == date.year 
  end
end
