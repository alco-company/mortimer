class Pupil < AbstractResource
  include Assetable, Assignable

  has_and_belongs_to_many :employees

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Pupil.all.joins(:asset)
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
