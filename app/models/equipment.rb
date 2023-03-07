class Equipment < AbstractResource
  include Assetable

  has_secure_token :access_token
  has_one_attached :mug_shot

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Equipment.all.joins(:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' "
  end

end
