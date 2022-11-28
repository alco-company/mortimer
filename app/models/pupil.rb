class Pupil < AbstractResource
  include Assetable, Assignable

  has_and_belongs_to_many :employees
  has_many :pupil_transactions

  validates :pin_code, uniqueness: true

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Pupil.all.joins(:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' or pin_code='#{query}'"
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

  def broadcast_create

  end

  def broadcast_update
    employees.each do |employee|
      broadcast_replace_later_to "employee_#{employee.asset.id}_pupils", 
        partial: "pos/employees/employee_pupils", 
        target: "pupils", 
        locals: { resource: employee.asset, user: Current.user }
    end
  end

end
