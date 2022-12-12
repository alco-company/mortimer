class AssetWorkTransactionService < EventService
    
  #
  # first we need to set the Current.account and Current.user
  # it may result in the first user in this account = account.administrator
  #
  def create_employee_punch_transaction resource, params
    set_current_data resource
    create_asset_work_transaction( resource, params )
  end

  #
  # when doing automated punches - ie employees did mark their calendar
  # in advance saying what this day will be chalked up for - 
  # we will use the employee to set the Current.account and Current.user
  #
  def create_automated_employee_punch_transaction resource, params
    set_current_data resource 

    params["state"] ||= "OUT"
    create_asset_work_transaction( resource, params )
  end

  #
  # TODO: create a logfile where all transactions are listed - and possibly can be edited and rerun
  #
  #
  # then we create a punch_action - because that's what really happened - no matter what we
  # have on records - we need to trust the client UI!
  #
  # to do that, we need todays punch_card (asset_workday_sum) 
  #
  def create_asset_work_transaction employee_asset, params

    # create transaction
    awt = create_transaction employee_asset, params

    # set employee state
    employee_asset.update state: params["state"]


    # now perform any calculations required based on the current state 
    # TODO make this part a job to perform_later
    # calculate_punch_consequence awt, params
  # rescue RuntimeError => err
  #   Rails.logger.info "[asset_work_transaction] Error: (AssetWorkTransaction) #{err.message}"
  end

  #
  # create the asset_work_transaction and event records
  def create_transaction asset, params
    e = nil
    return e unless [ "IN", "OUT", "BREAK", "SICK", "FREE" ].include? params["state"]

    awd = AssetWorkdaySumService.new.get_todays_worksum asset, Date.parse(params["punched_at"])
    punch_clock_asset = Asset.find(params["punch_asset_id"]) rescue nil
    AssetWorkTransaction.transaction do
      begin      
        awt = AssetWorkTransaction.new
        comment = params["comment"] rescue ""

        awt.asset = asset
        awt.punch_asset = punch_clock_asset
        awt.asset_workday_sum = awd
        awt.punch_asset_ip_addr = params["ip_addr"]
        awt.punched_at = params["punched_at"]
        awt.punched_geo = params["location"]
        awt.reason = params["reason"]

        comment = case awt.reason 
        when nil; comment
        when ""; comment
        when "-"; "ferie"
        when "XTRA"; "overtid " + comment
        when "ME"; "er selv syg"
        when "RR"; "ferie/fri"
        when "CHILD"; "barn syg"
        when "NURSING"; "omsorg"
        when "SENIOR"; "senior"
        when "UNPAID"; "selvbetalt"
        when "LOST_WORK"; "tabt arbejdsfortjeneste"
        when "MATERNITY"; "barsel"
        when "LEAVE"; "orlov"
        when "P56"; "paragraf 56"
        end

        e = Event.create( 
          account: Current.account, 
          name: comment,
          state: params["state"], 
          calendar: (asset.calendar || Current.account.calendar),
          eventable: (awt.save ? awt : nil)
        )
      rescue => err
        Rails.logger.info "[asset_work_transaction] Error: (create_transaction) #{err.message}"
        raise ActiveRecord::Rollback
      end
    end
    e
  end

  #
  # now do any calculations as consequences of the punch
  def calculate_punch_consequence awt, params
    return calculate_automated_consequences(awt, params) unless params["event_type"].nil?
    
    case e.state 
    when "IN"
      # find the previous BREAK and calc the diff
      # t.integer "break_minutes"
    when "OUT"
      # find the previous IN and calc the diff
      # t.integer "work_minutes"
      # t.integer "ot1_minutes"
      # t.integer "ot2_minutes"
    when "SICK"
      # t.integer "sick_minutes"
      # t.integer "child_sick_minutes" - Barns 1. sygedag
      # t.integer "pgf56_minutes" - pgf 56 sygdom
    end

  end

  #
  # every night at 00:01 all employees' asset_workday_sum for the
  # previous day are (re)calculated - called from AssetWorkdaySumJob
  #
  def calculate_automated_consequences awt, params 
    
    case params[:event_type]
    when "free_minutes"                     #  - ferie
    when "free_prev_minutes"                #  - ferie sidste år
    when "holiday_free_minutes"             #  - Feriefridage
    when "nursing_minutes"                  #  - Omsorgsdage
    when "senior_minutes"                   #  - Seniordage
    when "unpaid_free_minutes"              #  - Fri uden løn
    when "lost_work_revenue_minutes"        #  - Tabt arbejdsfortjeneste
    when "child_leave_minutes"              #  - Barselsorlov
    when "leave_minutes"                    #  - Orlov (sygdom forældre eller ægtefælle)
    end

  end



  # calc_awd calculates the time spent on various activities
  # for the current date of registration
  #
  def calc_awd employee_asset, current_awt, awd

    # _yesterday does not necessarily literally mean yesterday only any other day previously
    last_punch_yesterday = employee_asset.asset_work_transactions.where( 'punched_at < ?', current_awt.punched_at.at_beginning_of_day ).last rescue nil
    last_state = last_punch_yesterday.state rescue nil
    last_punch_at = last_punch_yesterday.punched_at rescue nil
    case last_state
    when 'IN','FREE','SICK','BREAK'
      start_time = last_punch_at
    else
      start_time = nil
    end
    
    AssetWorkTransaction.where( 'punched_at > ?', current_awt.punched_at.at_beginning_of_day ).order(punched_at: :asc).each do |awt|
      case awt.state
      when 'IN';    start_time, time_spent = start_in_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'BREAK'; start_time, time_spent = start_break_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'FREE';  start_time, time_spent = start_free_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'SICK';  start_time, time_spent = start_sick_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'OUT';   start_time, time_spent = start_out_minutes( awt, last_state, employee_asset, awd, start_time )
      else raise "AssetWorkTransaction cannot process #{awt.state}!"
      end
      last_state = awt.state
      awt.event.update minutes_spent: time_spent
    end

  end

  #
  # employee punched IN
  #
  def start_in_minutes( awt, last_state, employee_asset, awd, start_time )
    time_spent = 0
    case last_state
    when nil 
      awd.update work_minutes: 0, break_minutes: 0, free_minutes: 0, sick_minutes: 0
      start_time = awt.punched_at
    when 'OUT'
      start_time = awt.punched_at
    when 'IN'
      raise "last_state was IN so #{employee_asset.name} cannot punch in again!"
    when 'FREE'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update free_minutes: (awd.free_minutes + time_spent)
    when 'SICK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update sick_minutes: (awd.sick_minutes + time_spent)
    when 'BREAK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update break_minutes: (awd.break_minutes + time_spent)
    end    
    [start_time, time_spent]
  end

  #
  # employee punched OUT
  #
  def start_out_minutes( awt, last_state, employee_asset, awd, start_time )
    time_spent = 0
    case last_state
    when nil 
      start_time = nil
    when 'OUT'
      raise "last_state was OUT so #{employee_asset.name} cannot punch directly to out!"
    when 'SICK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update sick_minutes: (awd.sick_minutes + time_spent)          
    when 'FREE'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update free_minutes: (awd.free_minutes + time_spent)
    when 'IN'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update work_minutes: (awd.work_minutes + time_spent)          
    when 'BREAK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update break_minutes: (awd.break_minutes + time_spent)
    end
    [start_time, time_spent]
  end

  #
  # employee punched SICK
  #
  def start_sick_minutes( awt, last_state, employee_asset, awd, start_time )
    time_spent = 0
    case last_state
    when nil 
      start_time = awt.punched_at
    when 'OUT'
      start_time = awt.punched_at
    when 'SICK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update sick_minutes: (awd.sick_minutes + time_spent)          
    when 'IN'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update work_minutes: (awd.work_minutes + time_spent)          
    when 'BREAK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update break_minutes: (awd.break_minutes + time_spent)
    end
    [start_time, time_spent]
  end

  #
  # employee punched BREAK
  #
  def start_break_minutes( awt, last_state, employee_asset, awd, start_time )
    time_spent = 0
    case last_state
    when nil 
      start_time = awt.punched_at
    when 'OUT'
      raise "last_state was OUT so #{employee_asset.name} cannot punch directly to break!"
    when 'SICK'
      raise "last_state was SICK so #{employee_asset.name} cannot punch directly to break!"
    when 'IN'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update work_minutes: (awd.work_minutes + time_spent)          
    when 'BREAK'
      raise "last_state was BREAK so #{employee_asset.name} cannot punch break again!"
    end
    [start_time, time_spent]
  end

  #
  # employee punched FREE
  #
  def start_free_minutes( awt, last_state, employee_asset, awd, start_time )
    time_spent = 0
    case last_state
    when nil 
      start_time = awt.punched_at
    when 'OUT'
      start_time = awt.punched_at
    when 'IN'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update work_minutes: (awd.work_minutes + time_spent)
    when 'FREE'
      raise "last_state was FREE so #{employee_asset.name} cannot punch free again!"
    when 'SICK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update sick_minutes: (awd.sick_minutes + time_spent)
    when 'BREAK'
      time_spent = calc_distance_in_minutes( awt.punched_at, start_time )
      start_time = awt.punched_at
      awd.update break_minutes: (awd.break_minutes + time_spent)
    end    
    [start_time, time_spent]
  end

  def calc_distance_in_minutes to, from
    (to.to_i - from.to_i) / 60
  end
   
  def set_current_data asset
    Current.account ||= Asset.unscoped.where(assetable: employee).first.account
    Current.user ||= (Current.account.users.first || User.unscoped.first)
  end

end