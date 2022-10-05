# t.bigint "account_id", null: false
# t.bigint "asset_id", null: false
# t.date "work_date"
# t.integer "work_minutes"
# t.integer "break_minutes"
# t.integer "ot1_minutes"
# t.integer "ot2_minutes"
# t.integer "sick_minutes"
# t.integer "free_minutes"
# t.datetime "deleted_at"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["account_id"], name: "index_asset_workday_sums_on_account_id"
# t.index ["asset_id"], name: "index_asset_workday_sums_on_asset_id"

class AssetWorkdaySumService < AbstractResourceService
  
  def new_from_employee_asset employee_asset, dato 
    AssetWorkdaySum.new( account: employee_asset.account, 
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
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end

  def update( resource, resource_params, resource_class )
    result = super(resource,resource_params)
    if result.status != :updated 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end


  
end