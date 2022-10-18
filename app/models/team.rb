class Team  < AbstractResource
  include Participantable

  belongs_to :task, optional: true

  has_many :participant_teams
  has_many :participants, through: :participant_teams

  has_many :asset_teams
  has_many :assets, through: :asset_teams

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("participant" deleted_at: nil)
    Team.all.joins(:participant)
  end

  def employees 
    assets.where(assetable_type: 'Employee')
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "participants.name like '%#{query}%' "
  end
  
  def members
    participants.count
  end
end
