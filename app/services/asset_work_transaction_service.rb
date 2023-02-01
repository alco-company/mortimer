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

    awt

  rescue RuntimeError => err
    Rails.logger.info "[asset_work_transaction] Error: (AssetWorkTransaction) #{err.message}"
  end

  #
  # create the asset_work_transaction and event records
  # { "asset_work_transaction"=>{ "punched_at"=>"2023-02-01T09:26:51.030Z", "state"=>"IN", "punched_pupils"=>{}, "reason"=>"XTRA", "comment"=>"lave mere ballade", "location"=>"56.16683196518862,9.562318317858363,location retrieved!"}, "api_key"=>"[FILTERED]", "id"=>"4", "employee"=>{}}
  # { "asset_work_transaction"=>{ "punched_at"=>"2023-02-01T07:54:06.543Z", "state"=>"SICK", "sick_hrs"=>"5.35", "reason"=>"ME", "punched_pupils"=>{}, "location"=>"56.166814800165525,9.562304015232112,location retrieved!"}, "api_key"=>"[FILTERED]", "id"=>"2", "employee"=>{}}
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

        minutes = case params["state"]
        when "SICK";   get_decimal_minutes(params["sick_hrs"])
        when "FREE";   get_decimal_minutes(params["free_hrs"])
        else;          0
        end

        comment = case awt.reason 
        when nil;           comment
        when "";            comment
        when "-";           "ferie"
        when "XTRA";        "på overtid for at lave " + comment
        when "SUB";         "som vikar for at hjælpe på " + (Location.find(comment).name rescue '-')
        when "ME";          "er selv syg"
        when "RR";          "ferie/fri"
        when "CHILD";       "pga barn syg"
        when "NURSING";     "omsorg"
        when "SENIOR";      "senior"
        when "UNPAID";      "selvbetalt"
        when "LOST_WORK";   "efter reglen om tabt arbejdsfortjeneste"
        when "MATERNITY";   "barsel"
        when "LEAVE";       "orlov"
        when "P56";         "efter paragraf 56"
        end

        e = Event.create( 
          account: Current.account, 
          name: comment,
          state: params["state"], 
          calendar: (asset.calendar || Current.account.calendar),
          minutes_spent: minutes,
          eventable: (awt.save ? awt : nil)
        )
      rescue => err
        Rails.logger.info "[asset_work_transaction] Error: (create_transaction) #{err.message}"
        raise ActiveRecord::Rollback
      end
    end
    e
  end

  def get_decimal_minutes time
    hrs,min = time.split(",")
    min ||= "0"
    hrs ||= "0"
    hrs.to_i * 60 + min.to_i
  rescue
    0
  end
   
  def set_current_data asset
    Current.account ||= Asset.unscoped.where(assetable: employee).first.account
    Current.user ||= (Current.account.users.first || User.unscoped.first)
  end

end