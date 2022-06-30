class Participant < AbstractResource
  has_ancestry

  belongs_to :account
  belongs_to :calendar, optional: true

  has_many :participant_teams
  has_many :teams, through: :participant_teams

  has_many :roleables, as: :roleable, dependent: :delete_all
  has_many :roles, through: :roleables
  
  delegated_type :participantable, types: %w[ Supplier Customer User Team ], dependent: :destroy
  accepts_nested_attributes_for :participantable

  accepts_nested_attributes_for :roles

  before_create :create_calendar_if_missing

  def create_calendar_if_missing 
    self.calendar = account.calendar || Calendar.create( name: account.name) if calendar.nil?
  end

  def roles= rs 
    roles.delete_all
    rs.each{ |r| Roleable.create( role: Role.find(r), roleable: self) unless (r.blank? || r=='undefined') }
  end

  def combo_values_for_roles
    roles
  end

  def combo_values_for_teams
    teams
  end

  def teams= ts 
    teams.delete_all
    ts.each{ |t| ParticipantTeam.create( team: Team.find(t), participant: self) unless t.blank? }
  end

  #
  # called by resource_control when creating new resources
  # for the #new action
  def self.new_rec r
    self.new participantable: r.new
  end
  
  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_create
    broadcast_prepend_later_to self.participantable_type.underscore.pluralize, 
      target: "#{self.participantable_class.to_s.underscore}_list", 
      partial: self.participantable, 
      locals: {resource: self.participantable, user: Current.user }
  end
  
  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_update
    if self.deleted_at.nil? 
      broadcast_replace_later_to self.participantable_type.underscore.pluralize, 
        partial: self.participantable, 
        target: self.participantable, 
        locals: {resource: self.participantable, user: Current.user }
    else 
      broadcast_remove_to self.participantable_type.underscore.pluralize, target: self.participantable
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
