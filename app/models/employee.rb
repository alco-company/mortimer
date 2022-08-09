class Employee < AbstractResource
  include Assetable, Assignable

  has_secure_token :access_token
  has_one_attached :mug_shot
  has_and_belongs_to_many :pupils
  accepts_nested_attributes_for :pupils, allow_destroy: true

  validates :pin_code, uniqueness: true
  
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Employee.all.joins(:asset)
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

end
