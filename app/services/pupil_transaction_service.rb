class PupilTransactionService < EventService
    
  def create_pupil_transaction params, employee
    pupil = Pupil.unscoped.find( params['pupil_id'])
    return unless pupil
    return if params['state'] == pupil.state
    case params['state']
    when 'IN'; add_pupil_transaction pupil, employee, params
    when 'OUT'; update_pupil_transaction pupil, employee, params
    end    
  end

  def close_active_pupils resource, event, params
    params['punched_pupils'].each do |p|
      pupil = Pupil.unscoped.find p[0].split("_")[1]
      if pupil 
        update_pupil_transaction pupil, resource.assetable, params
      end
    end
  rescue
    say "-- probably no Pupils provided"
  end

  def add_pupil_transaction pupil, employee, params
    parms = { asset_id: params[:employee_asset_id],          # employee.asset
      pupil: pupil,
      state: 'IN',
      punched_at: params['punched_at'],
      punched_geo: params[:location],
      work_minutes: 0
    }
    acc = employee.asset.account
    e = Event.create( account: acc, 
      name: pupil.name,
      state: 'IN', 
      calendar_id: (pupil.calendar || employee.calendar),
      eventable: PupilTransaction.create( parms )
    )

    pupil.asset.update state: 'IN'
  end

  def update_pupil_transaction pupil, employee, params 
    last_pt = pupil.pupil_transactions.where(asset: params[:employee_asset_id]).where(state: 'IN').where('punched_at < ?', params['punched_at']).last         # .where(work_minutes: 0)
    unless last_pt.nil?
      parms = { asset_id: params[:employee_asset_id],
        pupil: pupil,
        state: 'OUT',
        punched_at: params['punched_at'],
        punched_geo: params["location"],
        work_minutes: calc_work_minutes(params['punched_at'], last_pt)#event.eventable.asset_workday_sum.work_minutes,
      }
      acc = employee.account
      e = Event.create( account: acc, 
        name: pupil.name,
        state: 'OUT', 
        calendar_id: (pupil.calendar || employee.calendar),
        eventable: PupilTransaction.create( parms )
      )
  
      pupil.asset.update state: 'OUT'
      pupil.update time_spent_minutes: (pupil.time_spent_minutes|| 0) + e.eventable.work_minutes
    end
  end

  def calc_work_minutes to, last_pt 
    from = last_pt.punched_at 
    to = DateTime.parse(to)
    (to.to_i - from.to_i) / 60
  end

end