class Role < AbstractResource
  AUTHORIZATIONS = %w(Index Show New Edit Create Update Delete Print Forward)

  belongs_to :account

  validates :name, presence: true
  validates :role, presence: true 


  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    where(deleted_at: nil, account: Current.account)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "name like '%#{query}%' "
  end


  # def broadcast_update 
  #   if self.deleted_at.nil? 
  #     broadcast_replace_later_to model_name.plural, partial: self, locals: { resource: self }
  #   else 
  #     broadcast_remove_to model_name.plural, target: self
  #   end
  # end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

  #
  # actions = :index, :show, :new, :edit, :create, :update, :destroy/:delete, :print, :share/:send/:forward
  # role = ISNECUDPF
  # endpoint = product | role | user | ..
  #
  def can action, endpoint
    return false unless ((context==' ') || (context.split(' ').include?( endpoint )))
    return false if (role =~ Regexp.new( action.to_s[0].upcase)).nil?
    true
  rescue => err
    false
  end
end
