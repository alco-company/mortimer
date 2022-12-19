class Account < AbstractResource
  validates :name, presence: true, uniqueness: true

  has_many :users, inverse_of: :account
  has_many :events, inverse_of: :account
  has_many :participants, inverse_of: :account
  has_many :assets, inverse_of: :account
  has_many :system_parameters, inverse_of: :account

  belongs_to :calendar, optional: true
  has_and_belongs_to_many :services
  accepts_nested_attributes_for :services, allow_destroy: true

  belongs_to :dashboard, optional: true

  has_one_attached :logo

  before_create :create_dashboard_if_missing
  before_create :create_calendar_if_missing

  def create_dashboard_if_missing
    if dashboard.nil?
      d = Dashboard.create(name:, layout: 'application')
      self.dashboard = d
    end
  end

  def create_calendar_if_missing
    self.calendar = Calendar.create(name:) if calendar.nil?
  end

  #
  # default_scope returns all posts that have not been marked for deletion yet
  # define default_scope on model if different
  #
  def self.default_scope
    where(deleted_at: nil)
  end

  def signed_services=(srv)
    return if srv.keys.map{|k|k.to_i}.sort == services.pluck( :id).sort
    services.delete_all
    srv.keys.each { |k| services << Service.find(k) }
  end

  def system_parameters_include system_key, value=nil
    parm = system_parameters.where(system_key: system_key).first rescue nil
    return false if parm.nil?
    return parm.value if (parm and value.nil?) rescue nil
    parm.value.include? value
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields(_lot, query)
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

  #
  # methods supporting broadcasting
  #
  def broadcast_create
    broadcast_prepend_later_to model_name.plural, target: "#{self.class.to_s.underscore}_list", partial: self,
                                                  locals: { resource: self, user: Current.user }
  rescue
  end

  def broadcast_update
    if deleted_at.nil?
      broadcast_replace_later_to model_name.plural, partial: self,
                                                    locals: { resource: self, user: Current.user }

      broadcast_replace_later_to [Current.account, :account], target: "desktop_menu", partial: "shared/menu_desktop",
                                                    locals: { resource: self, user: Current.user }
      broadcast_replace_later_to [Current.account, :account], target: "mobile_menu", partial: "shared/menu_mobile",
                                                    locals: { resource: self, user: Current.user }
                                                    
    else
      broadcast_remove_to model_name.plural, target: self
    end
  rescue
  end

end
