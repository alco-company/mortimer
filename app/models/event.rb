#
# :account - which account does this event belong to
# :eventable - what kind of event is this (call/todo/appointment/...)
# :calendar_id - what calendar does this event belong to
# :name - event description
# :state - what is the current state of this event (dependable upon the eventable)
# :position - if ordered somewhat - what position does this event hold
# :ancestry - if hierachically ordered - where in the 'tree' does this event sit
# :started_at - once started, we should know
# :ended_at - once finished, we should know too
# :minutes_spent - how many minutes did this event 'take to finish'
#
#
# Event is one in 4 core entities - together with Participants, Assets, and Messages
# and together they make any data relation possible; with the supporting tables close by
# obviously! EventTransactions persist every manipulation of delegated events
#
class Event < AbstractResource
  has_ancestry
  
  belongs_to :account, inverse_of: :events
  belongs_to :calendar, optional: true
  has_many :assignments, inverse_of: :event
  has_many :event_transactions, inverse_of: :event
  # has_many :participants, through: :assignments, source: "assignable", source_type: "Participant"
  # has_many :employees, through: :assignments, source: "assignable", source_type: "Employee"
  # has_many :messages, through: :assignments, source: "assignable", source_type: "Message"
  # has_many :event_transactions
  delegated_type :eventable, types: %w[ Call Task StockItemTransaction AssetWorkdayTransaction ], dependent: :destroy

  accepts_nested_attributes_for :eventable, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :assignments, reject_if: :all_blank, allow_destroy: true

  before_create :create_calendar_if_missing
  def create_calendar_if_missing 
    self.calendar = account.calendar || Calendar.create( name: account.name) if calendar.nil?
  end

  #
  # called by resource_control when creating new resources
  # for the #new action
  def self.new_rec r
    self.new eventable: r.new
  end

  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_create
    broadcast_prepend_later_to self.eventable_type.underscore.pluralize, 
      target: "#{self.eventable_class.to_s.underscore}_list", 
      partial: self.eventable, 
      locals: { resource: self.eventable, user: Current.user }
    self.eventable.broadcast_create if self.eventable

  end
  
  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_update
    if self.deleted_at.nil? 
      broadcast_replace_later_to self.eventable_type.underscore.pluralize, 
        partial: self.eventable, 
        target: self.eventable, 
        locals: { resource: self.eventable, user: Current.user }
    else 
      broadcast_remove_to self.eventable_type.underscore.pluralize, target: self.eventable
    end
    self.eventable.broadcast_update if self.eventable
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
