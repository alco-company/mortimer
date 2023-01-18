class Contact  < AbstractResource
  include Participantable

  belongs_to :employer, optional: true, class_name: 'Participant', foreign_key: :participant_id

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("participant" deleted_at: nil)
    Contact.all.joins(:participant)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "participants.name like '%#{query}%' or job_title like '%#{query}%' "
  end

end
