class ParticipantService < AbstractResourceService
 
  def get_by field, val, parm, participantable 
    (Participant.find_by(field => val) rescue nil) || create( Participant.new(parm),participantable)
  end

  def create( resource )
    resource.calendar = Calendar.new(name: resource.name) if resource.calendar_id.blank?
    result = super(resource)
    if result.status != :created 
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end

  def update( resource, resource_params )
    result = super(resource,resource_params )
    if result.status != :updated
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end

end