class PupilTransactionService < EventService
    
  def create_pupil_transaction resource, event, params
    if event.state != 'IN'
      pupils = resource.assetable.pupils.where( 'assets.state = ?', 'IN')
    else
      pupils = []
      params['punched_pupils'].each do |pupil|
        pupils.push Pupil.find(pupil[0].gsub('pupil_',''))
      end
    end
    create_transactions resource, pupils, event, params
  end

  def create_transactions resource, pupils, event, params

    case event.state
    when 'IN'; pupils.each{ |p| add_pupil_transaction p, resource, event, params }
    when 'OUT'; pupils.each{ |p| update_pupil_transaction p, resource, event, params } 
    end

  end

  def add_pupil_transaction pupil, resource, event, params
    parms = { asset: resource,
      pupil: pupil,
      state: 'IN',
      punched_at: event.eventable.punched_at,
      work_minutes: 0
    }
    acc = resource.account
    e = Event.create( account: acc, 
      name: pupil.name,
      state: 'IN', 
      calendar_id: (pupil.calendar || acc.calendar),
      eventable: PupilTransaction.create( parms )
    )

    pupil.asset.update state: 'IN'
  end

  def update_pupil_transaction pupil, resource, event, params 
    last_pt = pupil.pupil_transactions.where(asset: resource).where(state: 'IN').where(work_minutes: 0).where('punched_at < ?', event.eventable.punched_at).last
    unless last_pt.nil?
      parms = { asset: resource,
        pupil: pupil,
        state: 'OUT',
        punched_at: event.eventable.punched_at,
        work_minutes: calc_work_minutes(event, last_pt)#event.eventable.asset_workday_sum.work_minutes,
      }
      acc = resource.account
      e = Event.create( account: acc, 
        name: pupil.name,
        state: 'OUT', 
        calendar_id: pupil.calendar || acc.calendar,
        eventable: PupilTransaction.create( parms )
      )
  
      pupil.asset.update state: 'OUT'
      pupil.update time_spent_minutes: (pupil.time_spent_minutes|| 0) + e.eventable.work_minutes
    end
  end

  def calc_work_minutes event, last_pt 
    from = last_pt.punched_at 
    to = event.eventable.punched_at 
    (to.to_i - from.to_i) / 60
  end

end