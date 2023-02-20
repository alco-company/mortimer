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

class AssetWorkdaySumService < AbstractResourceService

  def get_todays_worksum employee_asset, dato 
    awd = employee_asset.asset_workday_sums.where(work_date: dato).first
    if awd.nil?
      result = create( new_from_employee_asset( employee_asset, dato) ) 
      raise "AssetWorkdaySum could not be created!" unless result.created?
      awd = result.record
    end
    awd
  rescue
    nil
  end
  
  def new_from_employee_asset employee_asset, dato 
    AssetWorkdaySum.new( account: employee_asset.account, 
      asset: employee_asset,
      work_date: dato.at_beginning_of_day,
      work_minutes: 0,
      break_minutes: 0,
      free_minutes: 0,
      free_prev_minutes: 0,
      holiday_free_minutes: 0,
      unpaid_free_minutes: 0,
      ot1_minutes: 0,
      ot2_minutes: 0,
      sick_minutes: 0,
      child_sick_minutes: 0,
      nursing_minutes: 0,
      senior_minutes: 0,
      lost_work_revenue_minutes: 0,
      child_leave_minutes: 0,
      leave_minutes: 0,
      pgf56_minutes: 0,
    )
  end

  def update_workday_sum( resource, event )
    event.eventable.asset_workday_sum.calculate_on_transactions self 
  rescue => e
    puts "AssetWorkdaySumService.update_workday_sum failed due to: #{e.message}"
  end

  #
  # This is how we calculate the work_minutes, ot1_minutes, ot2_minutes in standard Mortimer!
  #
  # Gets called from the AssetWorkdaySum model instance method calculate_on_transactions
  #
  def calc_work awds, minutes, punch_type      
    return false unless %w( work_minutes ot1_minutes ot2_minutes ).include? punch_type.to_s
    awds.asset.assetable.norm_time = 37 if awds.asset.assetable.norm_time.nil?

    if punch_type.to_s == 'work_minutes'
      minutes = awds.work_minutes + minutes
      if minutes > (awds.asset.assetable.norm_time * 60 / 5).round
        minutes = awds.work_minutes - (awds.asset.assetable.norm_time * 60 / 5).round
        awds.update_column :work_minutes, (awds.asset.assetable.norm_time * 60 / 5).round
        punch_type = :ot1_minutes
      else
        awds.update_column :work_minutes, minutes
      end
    end

    # if ot1_minutes
    if (%w( ot1_minutes ot2_minutes ).include? punch_type.to_s) and (minutes > 0)
      t1 = awds.ot1_minutes + awds.ot2_minutes + minutes 
      t2 = t1 - 180
      awds.update_column :ot1_minutes, t1 < 181 ? t1 : 180
      awds.update_column :ot2_minutes, t2 if t2 > 0
    end
    return true

  end

  
end