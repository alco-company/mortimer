class Team  < AbstractResource
  include Participantable

  belongs_to :task, optional: true
  belongs_to :calendar, optional: true

  has_many :participant_teams
  has_many :participants, through: :participant_teams

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("participant" deleted_at: nil)
    Team.all.joins(:participant)
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
