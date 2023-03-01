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

  # validate :future_date

  def future_date
    errors.add(:punched_at, :invalid) if punched_at < Time.now
  end

  def self.default_scope
    AssetWorkTransaction.all.joins(:event,:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields(_lot, query)
    default_scope.where "assets.name like '%#{query}%' "
  end

  def punched_pupils=(ppls)

  end

  def broadcast_create

    buttons = Current.account.system_parameters_include("pos/employee/buttons")

    broadcast_prepend_later_to model_name.plural, 
      target: "asset_work_transaction_list", 
      partial: self,
      locals: { resource: self, user: Current.user }

    broadcast_replace_later_to "employee_#{self.asset.id}_stats", 
      partial: "pos/employees/employee_stats", 
      target: "employee_stats", 
      locals: { resource: self.asset, user: Current.user }

    broadcast_replace_later_to "employee_#{self.asset.id}_state", 
      partial: "pos/employees/employee_state", 
      target: "employee_state", 
      locals: { resource: self.asset, reason: self.name, user: Current.user }
        
    broadcast_replace_later_to "employee_#{self.asset.id}_state_buttons", 
      partial: "pos/employees/employee_state_buttons", 
      target: "employee_state_buttons", 
      locals: { resource: self.asset, user: Current.user, buttons: buttons }
  end

end
