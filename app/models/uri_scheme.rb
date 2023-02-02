class UriScheme < AbstractResource
  
  validates :scheme, presence: true

  #
  # default_scope returns all posts that have not been marked for deletion yet
  # define default_scope on model if different
  #
  def self.default_scope
    where(deleted_at: nil)
  end


  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "scheme like '%#{query}%' or purpose like '%#{query}%' or state like '%#{query}%' or reference like '%#{query}%' or general_format like '%#{query}%' or notes like '%#{query}%'"
  end


  def broadcast_update 
    if self.deleted_at.nil? 
      broadcast_replace_later_to model_name.plural, 
        partial: self, 
        locals: { resource: self, user: Current.user }
    else 
      broadcast_remove_to model_name.plural, target: self
    end
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
