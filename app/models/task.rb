#
# :duration - what is the (planned) duration
# :planned_start_at - when is the task planned to start
# :planned_end_at - when is the task planned to end
# :location - a geospatial location - address or lng/lat
# :purpose - any additional identification of the task origin/demand/solution
# :recurring_ical - iCAL compiled event description
# :recurring_end_at - af this date no need to include recurring events into any lookups
# :full_day - is it a full day task? (for display purposes only)
#
class Task  < AbstractResource
  include Eventable

  # validates :duration, comparison: { greater_than: 100 }

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    Task.all.joins(:event)
  end


  #
  # Task - if updated without the event being 'called'
  #
  def broadcast_update
    if self.event.deleted_at.nil? 
      broadcast_replace_later_to 'task', 
        partial: self, 
        target: self, 
        locals: {resource: self, user: Current.user }
    else 
      broadcast_remove_to 'task', target: self
    end
  end

  def broadcast_destroy
    raise "Task should not be hard-deleteable!"
    # after_destroy_commit { broadcast_remove_to self, partial: self, locals: {resource: self} }
  end
  #
  #

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

end
