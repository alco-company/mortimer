#
#
# f_days_acc - accumulated number of holi-days (2,08 days pr month)
# ff_days - number of 'feriefridage' / 'omsorgsdage' - same same
# 
class Printserver < AbstractResource
  include Assetable

  validates :port, uniqueness: true
  
  def self.active
    where('assets.state': ['ON','PRINTING'])
  end

  def working?
    ['ON','PRINTING'].include? state
  end
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Printserver.all.joins(:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' or mac_addr ilike '%#{query}%' or port ilike '%#{query}%' "
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
    if self.asset.deleted_at.nil? 
      broadcast_replace_later_to 'printservers', 
        partial: self, 
        target: self, 
        locals: { resource: self, user: Current.user }
    else 
      broadcast_remove_to 'printservers', target: self
    end
  end

end
