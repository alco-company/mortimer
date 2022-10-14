class AssetWorkdaySum < AbstractResource
  belongs_to :account
  belongs_to :asset
  has_many :asset_work_transactions

  def broadcast_create

  end
  def broadcast_update
    
  end
end
