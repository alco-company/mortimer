class Asset < AbstractResource
  include Assignable

  has_ancestry
  
  belongs_to :account, inverse_of: :assets
  belongs_to :calendar, optional: true

  has_many :asset_workday_sums
  has_many :asset_work_transactions

  has_many :asset_teams
  has_many :teams, through: :asset_teams
  
  delegated_type :assetable, types: %w[ Employee Equipment Location Printserver Product PunchClock Pupil Stock StockLocation ], dependent: :destroy
  delegate :access_token, to: :assetable

  accepts_nested_attributes_for :assetable

  before_create :create_calendar_if_missing
  
  # TODO - add uri's to assetable
  def email 
    ""
  end

  def create_calendar_if_missing 
    self.calendar = account.calendar || Calendar.create( name: account.name) if calendar.blank?
  end

  def combo_values_for_teams
    teams
  end

  def combo_values_for_work_schedules
    work_schedules
  end

  def teams= ts 
    teams.delete_all
    ts.each{ |t| AssetTeam.create( team: Team.find(t), asset: self) unless t.blank? } if self.id
  end

  def work_schedules= ws 
    Assignment.where( assignable_type: 'Asset', event_id: Event.where(eventable_type: 'WorkSchedule', eventable_id: self.work_schedules.map( &:id) )).delete_all
    ws.each{ |w| Assignment.create( event: WorkSchedule.find(w).event, assignable: self) unless w.blank? } if self.id
    # ws.each{ |w| Assignment.create( event: w.event, assignable: asset) unless w.blank? } if self.id

  end

  #
  # called by resource_control when creating new resources
  # for the #new action
  def self.new_rec r
    self.new assetable: r.new
  end
  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_create
    broadcast_prepend_later_to self.assetable_type.underscore.pluralize, 
      target: "#{self.assetable_class.to_s.underscore}_list", 
      partial: self.assetable, 
      locals: { resource: self.assetable, user: Current.user }
    self.assetable.broadcast_create if self.assetable
    end
  
  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_update
    if self.deleted_at.nil? 
      broadcast_replace_later_to self.assetable_type.underscore.pluralize, 
        partial: self.assetable, 
        target: self.assetable, 
        locals: { resource: self.assetable, user: Current.user }
    else 
      broadcast_remove_to self.assetable_type.underscore.pluralize, target: self.assetable
    end
    self.assetable.broadcast_update if self.assetable 
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
