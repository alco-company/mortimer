class WorkSchedule < AbstractResource
  include Eventable
  
  # validates :name, presence: true, uniqueness: true 

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("assetable" deleted_at: nil)
      WorkSchedule.all.joins(:event)
    end
  
  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "name like '%#{query}%' "
  end

  def start_minute_string
    calc_from_minutes start_minute
  end

  def start_minute_string= val 
    self.start_minute = calc_minutes val
  end

  def end_minute_string
    calc_from_minutes end_minute
  end

  def end_minute_string= val 
    self.end_minute = calc_minutes val
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

  def calc_from_minutes fld 
    return if fld.blank?
    "%02i:%02i" % [fld/60,fld % 60]
  end

  def calc_minutes hr_min
    hr,min = hr_min.split(":")
    hr.to_i*60+min.to_i
  end

end
