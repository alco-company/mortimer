#
# event
#
# t.bigint "account_id", null: false
# t.string "eventable_type", null: false
# t.bigint "eventable_id", null: false
# t.bigint "calendar_id", null: false
# t.string "name"
# t.string "state"
# t.integer "position"
# t.string "ancestry"
# t.datetime "started_at"
# t.datetime "ended_at"
# t.integer "minutes_spent"
# t.datetime "deleted_at"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["account_id"], name: "index_events_on_account_id"
# t.index ["calendar_id"], name: "index_events_on_calendar_id"
# t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
#
# work_schedule
#
# create_table "work_schedules", force: :cascade do |t|
#   t.boolean "roll"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end
#
#
class WorkScheduleService < AbstractResourceService
  
  def create_work_schedule employee_asset, dato 
    Event.new( account: employee_asset.account, 
      asset: employee_asset,
      work_date: dato.at_beginning_of_day,
      work_minutes: 0,
      break_minutes: 0,
      ot1_minutes: 0,
      ot2_minutes: 0,
      sick_minutes: 0,
      free_minutes: 0
    )
  end

  def create( resource, resource_class )
    result = super(resource)
    if result.status != :created 
      resource.eventable = resource_class.new if resource.eventable.nil?
    end
    result
  end

  def update( resource, resource_params, resource_class )
    result = super(resource,resource_params)
    if result.status != :updated 
      resource.eventable = resource_class.new if resource.eventable.nil?
    end
    result
  end


  
end