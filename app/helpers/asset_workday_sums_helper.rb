module AssetWorkdaySumsHelper

  def display_hours_minutes minutes 
    minutes_left = minutes.to_i % 60
    "%02d:%02d" % [ minutes.to_i/60, minutes_left ]
  rescue 
    "-"
  end

  # # t.integer "work_minutes"                  IN          -           a           reason if substitute
  # # t.integer "break_minutes"                 BREAK       -           -           -
  # # t.integer "ot1_minutes"                   IN          -           XTRA        not nil            
  # # t.integer "ot2_minutes"                   IN          -           XTRA        not nil                       after 180min OT1

  def display_hours_this_week resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_week..date.at_end_of_week ).sum( :work_minutes)
  end

  def display_hours_this_month resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_month..date.at_end_of_month ).sum( :work_minutes)
  end

  def display_break_hours_this_week resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_week..date.at_end_of_week ).sum( :break_minutes)
  end

  def display_break_hours_this_month resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_month..date.at_end_of_month ).sum( :break_minutes)
  end

  def display_ot_hours_this_week resource, date=Date.today
    "OT1 %s / OT2 %s minutter" % [
      resource.asset_workday_sums.where(work_date: date.at_beginning_of_week..date.at_end_of_week ).sum( :ot1_minutes),
      resource.asset_workday_sums.where(work_date: date.at_beginning_of_week..date.at_end_of_week ).sum( :ot2_minutes)
    ]
  end

  def display_ot_hours_this_month resource, date=Date.today
    "OT1 %s / OT2 %s minutter" % [
      resource.asset_workday_sums.where(work_date: date.at_beginning_of_week..date.at_end_of_month ).sum( :ot1_minutes),
      resource.asset_workday_sums.where(work_date: date.at_beginning_of_week..date.at_end_of_month ).sum( :ot2_minutes)
    ]
  end

  # t.integer "holiday_free_minutes"          FREE        -           RR          -
  def display_rr_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :holiday_free_minutes)
  end

  # t.integer "senior_minutes"                FREE        -           SENIOR      -
  def display_senior_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :senior_minutes)
  end

  # t.integer "sick_minutes"                  SICK        -           ME          -                 9,99        that or norm_time / 5 punched as todays *_minutes
  def display_sick_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :sick_minutes)
  end

  # t.integer "free_minutes"                  FREE        -           -           -
  def display_free_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :free_minutes)
  end

  # t.integer "child_sick_minutes"            SICK        -           CHILD       -
  def display_child_sick_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :child_sick_minutes)
  end

  # t.integer "nursing_minutes"               SICK        -           NURSING     -
  def display_nursing_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :nursing_minutes)
  end

  # t.integer "unpaid_free_minutes"           FREE        -           UNPAID      -
  def display_unpaid_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :unpaid_free_minutes)
  end

  # t.integer "lost_work_revenue_minutes"     SICK        -           LOST_WORK   -
  def display_lost_work_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :lost_work_revenue_minutes)
  end

  # t.integer "child_leave_minutes"           FREE        -           MATERNITY   -
  def display_child_leave_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :child_leave_minutes)
  end

  # t.integer "leave_minutes"                 FREE        -           LEAVE       -
  def display_leave_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :leave_minutes)
  end

  # t.integer "free_prev_minutes" <-- when year = +1      -           -           -
  def display_free_prev_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :free_prev_minutes)
  end

  # t.integer "pgf56_minutes"                 SICK        -           P56         -
  def display_pgf56_account resource, date=Date.today
    "%s minutter" % resource.asset_workday_sums.where(work_date: date.at_beginning_of_year..date.at_end_of_year ).sum( :pgf56_minutes)
  end

end
