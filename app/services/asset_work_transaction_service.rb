class AssetWorkTransactionService < EventService
    
  def create_employee_punch_transaction params
    awparm=params["asset_work_transaction"]
    employee_asset = Employee.unscoped.find(awparm["employee_id"]).asset
    set_current_data employee_asset
    create_asset_work_transaction( employee_asset, awparm )
  end

  
  #
  # TODO: create a logfile where all transactions are listed - and possibly can be edited and rerun
  #
  def create_asset_work_transaction employee_asset, params
    w = case params["state"]
    when "IN"; create_in_transaction(employee_asset, params)
    when "OUT"; create_out_transaction(employee_asset, params)
    when "BREAK"; create_break_transaction(employee_asset, params)
    when "SICK"; create_sick_transaction(employee_asset, params)
    when "FREE"; create_free_transaction(employee_asset, params)
    else raise "state parameter (#{params["state"]}) is not implemented!"
    end
  rescue RuntimeError => err
    Rails.logger.info "[asset_work_transaction] Error: (AssetWorkTransaction) #{err.message}"
  end
  
  def create_in_transaction employee_asset, parms 
    punch_clock_asset = Asset.find(parms["punch_asset_id"])
    awt = nil
    AssetWorkTransaction.transaction do
      begin
        #
        # find employee workshift
        # and decide what to do with the IN state
        extra_time = 0

        # create transaction
        awt = create_transaction employee_asset, punch_clock_asset, extra_time, parms
        # run calc if employee.state in ['BREAK','SICK','FREE','OUT']
        calc_awd(employee_asset, awt.eventable)
        # set employee state
        employee_asset.update state: 'IN'
      rescue RuntimeError => err 
        Rails.logger.info "[asset_work_transaction] Error: (create_in_transaction) #{err.message}"
      end
    end
    awt
  end
  
  def create_break_transaction employee_asset, parms 
    punch_clock_asset = Asset.find(parms["punch_asset_id"])
    awt = nil
    AssetWorkTransaction.transaction do
      begin
        #
        # find employee workshift
        # and decide what to do with the IN state
        extra_time = 0

        # create transaction
        awt = create_transaction employee_asset, punch_clock_asset, extra_time, parms
        # run calc if employee.state in ['BREAK','SICK','FREE','OUT']
        calc_awd(employee_asset, awt.eventable)
        # set employee state
        employee_asset.update state: 'BREAK'

      rescue RuntimeError => err 
        Rails.logger.info "[asset_work_transaction] Error: (create_break_transaction) #{err.message}"
      end
    end
    awt
  end
  
  def create_sick_transaction employee_asset, parms 
    punch_clock_asset = Asset.find(parms["punch_asset_id"])
    awt = nil
    AssetWorkTransaction.transaction do
      begin
        #
        # find employee workshift
        # and decide what to do with the IN state
        extra_time = 0

        # create transaction - returns event
        awt = create_transaction employee_asset, punch_clock_asset, extra_time, parms
        # run calc if employee.state in ['BREAK','SICK','FREE','OUT']
        calc_awd(employee_asset, awt.eventable)
        # set employee state
        employee_asset.update state: 'SICK'

      rescue RuntimeError => err 
        Rails.logger.info "[asset_work_transaction] Error: (create_sick_transaction) #{err.message}"
      end
    end
    awt
  end
  
  def create_free_transaction employee_asset, parms 
    punch_clock_asset = Asset.find(parms["punch_asset_id"])
    awt = nil
    AssetWorkTransaction.transaction do
      begin
        #
        # find employee workshift
        # and decide what to do with the IN state
        extra_time = 0

        # create transaction - returns event
        awt = create_transaction employee_asset, punch_clock_asset, extra_time, parms
        # run calc if employee.state in ['BREAK','SICK','FREE','OUT']
        calc_awd(employee_asset, awt.eventable)
        # set employee state
        employee_asset.update state: 'FREE'

      rescue RuntimeError => err 
        Rails.logger.info "[asset_work_transaction] Error: (create_free_transaction) #{err.message}"
      end
    end
    awt
  end
  
  def create_out_transaction employee_asset, parms 
    punch_clock_asset = Asset.find(parms["punch_asset_id"])
    awt = nil
    AssetWorkTransaction.transaction do
      begin
        #
        # find employee workshift
        # and decide what to do with the IN state
        extra_time = 0

        # create transaction - returns event
        awt = create_transaction employee_asset, punch_clock_asset, extra_time, parms
        # run calc if employee.state in ['BREAK','SICK','FREE','OUT']
        calc_awd(employee_asset, awt.eventable)
        # set employee state
        employee_asset.update state: 'OUT'

      rescue RuntimeError => err 
        Rails.logger.info "[asset_work_transaction] Error: (create_out_transaction) #{err.message}"
      end
    end
    awt
  end
    
  def create_transaction asset, punch_clock_asset, extra_time, parms 
    begin      
      awt = AssetWorkTransaction.new
      
      awt.asset = asset
      awt.punch_asset = punch_clock_asset
      awt.punch_asset_ip_addr = parms["ip_addr"]
      awt.punched_at = parms["punched_at"]
      e = Event.create( 
        account: Current.account, 
        name: "AWT",
        state: parms["state"], 
        calendar: (asset.calendar || Current.account.calendar),
        eventable: (awt.save ? awt : nil)
      )
    rescue => err
      Rails.logger.info "[asset_work_transaction] Error: (create_transaction) #{err.message}"
      raise ActiveRecord::Rollback
    end
  end

  # calc_awd calculates the time spent on various activities
  # for the current date of registration
  #
  def calc_awd employee_asset, current_awt
    awd = employee_asset.asset_workday_sums.where(work_date: Date.today) 
    if awd.empty?
      result = AssetWorkdaySumService.new.create( 
      AssetWorkdaySumService.new.new_from_employee_asset( employee_asset, current_awt.punched_at.to_date ), Employee 
      ) 
      raise "AssetWorkdaySum could not be created!" unless result.created?
      awd = result.record
    end

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
      when 'IN';    start_time = start_in_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'BREAK'; start_time = start_break_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'FREE';  start_time = start_free_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'SICK';  start_time = start_sick_minutes( awt, last_state, employee_asset, awd, start_time )
      when 'OUT';   start_time = start_out_minutes( awt, last_state, employee_asset, awd, start_time )
      else raise "AssetWorkTransaction cannot process #{awt.state}!"
      end
      last_state = awt.state
    end

  end

  #
  # employee punched IN
  #
  def start_in_minutes( awt, last_state, employee_asset, awd, start_time )
    case last_state
    when nil 
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
    start_time
  end

  #
  # employee punched OUT
  #
  def start_out_minutes( awt, last_state, employee_asset, awd, start_time )
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
    start_time
  end

  #
  # employee punched SICK
  #
  def start_sick_minutes( awt, last_state, employee_asset, awd, start_time )
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
    start_time
  end

  #
  # employee punched BREAK
  #
  def start_break_minutes( awt, last_state, employee_asset, awd, start_time )
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
    start_time
  end

  #
  # employee punched FREE
  #
  def start_free_minutes( awt, last_state, employee_asset, awd, start_time )
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
    start_time
  end

  def calc_distance_in_minutes to, from
    (to.to_i - from.to_i) / 60
  end
   
  def set_current_data asset
    Current.account ||= Asset.unscoped.where(assetable: employee).first.account
    Current.user ||= (Current.account.users.first || User.unscoped.first)
  end

end