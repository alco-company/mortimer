class Calendar < AbstractResource
  has_many :events 
  has_many :assets

  has_many :work_schedules, through: :events, source: "eventable", source_type: "WorkSchedule"

  def self.default_scope
    where(deleted_at: nil)
  end

  # find all events pertaining to date
  # and punch them
  def punch_work_related_events datetime, owner_asset
    # events.where.not(eventable_type: "AssetWorkTransaction").where(started_at: [..datetime.end_of_day])
    # Event.unscoped.where( calendar_id: id, eventable_type: nil, started_at: (datetime.at_beginning_of_day)..((datetime+1.day).at_beginning_of_day)).each do |e|
    #   params = []
    #   AssetWorkTransactionService.new.create_automated_employee_punch_transaction owner_asset, params
    #   say "punch_work_related_events #{e.id}"
    # end
  end

end
