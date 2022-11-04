class Location< AbstractResource
  include Assetable

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #  
  def self.default_scope
    Location.all.joins(:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' "
  end


  def combo_values_for_asset_requirements
    []    
  end


end
