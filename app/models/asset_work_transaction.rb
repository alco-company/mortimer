#
# AssetWorkTransaction have only a few states
# IN - starting to work
# OUT - done working
# BREAK - taking a break/pause
# SICK - a broken down asset
# FREE - starting to not work - possibly planned in asset calendar
#
class AssetWorkTransaction < AbstractResource
  include Eventable
  
  belongs_to :asset
  belongs_to :asset_workday_sum, optional: true
  belongs_to :punch_asset, optional: true, class_name: "Asset"
  
  def self.default_scope
    AssetWorkTransaction.all.joins(:event)
  end

end
