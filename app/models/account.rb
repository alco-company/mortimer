class Account < AbstractResource
  
  validates :name, presence: true, uniqueness: true 

  has_many :users, inverse_of: :account
  has_many :events, inverse_of: :account
  has_many :participants, inverse_of: :account 
  has_many :assets, inverse_of: :account

  belongs_to :calendar, optional: true
  has_and_belongs_to_many :services
  accepts_nested_attributes_for :services, allow_destroy: true

  belongs_to :dashboard, optional: true

  before_create :create_dashboard_if_missing

  def create_dashboard_if_missing 
    if dashboard.nil?
      d = Dashboard.create( name: name, layout: "application") 
      self.dashboard = d
    end
  end

  def signed_services=srv 
    self.services.delete_all
    srv.keys.each{|k| self.services << Service.find(k)}
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "name like '%#{query}%' "
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
