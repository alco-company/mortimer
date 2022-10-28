module WorkSchedulesHelper

  #
  #
  #
  def show_team_work_schedules resource 
    ws = resource.teams.map(&:work_schedules).flatten.compact - resource.work_schedules
    ws.collect{ |w| link_to w.name, w, target: "_blank" }.join(" | ")
  end

  #
  # set eu false if week has to start with sunday (en/us format)
  # returns [ "S", "M", "T", "O", "T", "F", "L" ]
  #
  def weekdays eu=false
    wd = I18n.translate('date.day_names').collect{ |d| d[0].capitalize }
    return wd unless eu 
    wd.push wd.shift
  end

  #
  # return either true week number - or 1-indexed week number
  # all depending on boolean @week_planning
  def week_number day, week, week_planning
    return week if week_planning
    I18n.localize( day, format: :week_number)
  end
  
  #
  # return either true day number - or nothing
  # all depending on boolean @week_planning
  def day_number day, week_planning
    return "" if week_planning
    day.day
  end

  # Always include: "py-1.5 hover:bg-gray-100 focus:z-10"
  # Is current month, include: "bg-white"
  # Is not current month, include: "bg-gray-50"
  # Is selected or is today, include: "font-semibold"
  # Is selected, include: "text-white"
  # Is not selected, is not today, and is current month, include: "text-gray-900"
  # Is not selected, is not today, and is not current month, include: "text-gray-400"
  # Is today and is not selected, include: "text-indigo-600"

  # Top left day, include: "rounded-tl-lg"
  # Top right day, include: "rounded-tr-lg"
  # Bottom left day, include: "rounded-bl-lg"
  # Bottom right day, include: "rounded-br-lg"
  def day_classes week 
    [ "rounded-tl-lg",
      "",
      "",
      "",
      "",
      "rounded-bl-lg"
    ][week]
  end

  # Always include: "mx-auto flex h-7 w-7 items-center justify-center rounded-full"
  # Is selected and is today, include: "bg-indigo-600"
  # Is selected and is not today, include: "bg-gray-900"
  def time_classes day 
    ""
  end

end
