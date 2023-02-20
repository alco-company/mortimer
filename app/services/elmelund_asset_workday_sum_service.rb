# t.date "work_date"
# t.integer "work_minutes" - arbejde
# t.integer "break_minutes" - pauser
# t.integer "ot1_minutes" - overtid 50%
# t.integer "ot2_minutes" - overtid 100%
# t.integer "sick_minutes" - syg
# t.integer "pgf56_minutes" - pgf 56 sygdom
# t.integer "free_minutes" - ferie
# t.integer "free_prev_minutes" - ferie sidste år
# t.integer "holiday_free_minutes" - Feriefridage
# t.integer "child_sick_minutes" - Barns 1. sygedag
# t.integer "nursing_minutes" - Omsorgsdage
# t.integer "senior_minutes" - Seniordage
# t.integer "unpaid_free_minutes" - Fri uden løn
# t.integer "lost_work_revenue_minutes" - Tabt arbejdsfortjeneste
# t.integer "child_leave_minutes" - Barselsorlov
# t.integer "leave_minutes" - Orlov (sygdom forældre eller ægtefælle)

class ElmelundAssetWorkdaySumService < AssetWorkdaySumService

  #
  # This is how we calculate the work_minutes, ot1_minutes, ot2_minutes in Elmelund Mortimer!
  #
  # Gets called from the AssetWorkdaySum model instance method calculate_on_transactions
  #
  def calc_work awds, minutes, punch_type      
    return false unless %w( work_minutes ).include? punch_type.to_s

    if punch_type.to_s == 'work_minutes'
      minutes = awds.work_minutes + minutes
      awds.update_column :work_minutes, minutes
    end

    return true

  end
  
end