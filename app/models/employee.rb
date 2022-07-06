class Employee < AbstractResource
  include Assetable, Assignable

  has_secure_token :access_token
  has_one_attached :mug_shot

  validates :pin_code, uniqueness: true
  
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Employee.all.joins(:asset)
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

end
