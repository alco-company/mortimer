class ParticipantService < AbstractResourceService
  def create( resource )
    result = super(resource)
    if result.status == :not_valid 
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end

  def update resource, resource_params
    result = super(resource,resource_params)
    if result.status == :not_valid 
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end
end