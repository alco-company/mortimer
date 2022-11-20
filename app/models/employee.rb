#
#
# f_days_acc - accumulated number of holi-days (2,08 days pr month)
# ff_days - number of 'feriefridage' / 'omsorgsdage' - same same
# 
class Employee < AbstractResource
  include Assetable

  has_secure_token :access_token
  has_one_attached :mug_shot
  has_and_belongs_to_many :pupils

  accepts_nested_attributes_for :pupils, allow_destroy: true

  validates :pin_code, uniqueness: true

  delegate :asset_work_transactions, :asset_workday_sums, :teams, to: :asset
  
  def self.working
    where('assets.state': ['IN','BREAK'])
  end
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Employee.all.joins(:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' "
  end

  def signed_pupils=(ppls)
    pupils.delete_all
    ppls.keys.each { |k| pupils << Pupil.find(k) }
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

  def broadcast_update
    broadcast_replace_later_to "employee_#{self.id}_calendar", 
      partial: "employees/calendar", 
      target: "employee_#{self.id}_calendar", 
      locals: { resource: self, user: Current.user }

      broadcast_replace_later_to "employee_#{self.asset.id}_pupils", 
      partial: "pos/employees/employee_pupils", 
      target: "pupils", 
      locals: { resource: self.asset, user: Current.user }
      
    broadcast_replace_later_to "employee_#{self.asset.id}_state", 
      partial: "pos/employees/employee_state", 
      target: "employee_state", 
      locals: { resource: self.asset, user: Current.user }
        
    broadcast_replace_later_to "employee_#{self.asset.id}_state_buttons", 
      partial: "pos/employees/employee_state_buttons", 
      target: "employee_state_buttons", 
      locals: { resource: self.asset, user: Current.user }

  end

end
