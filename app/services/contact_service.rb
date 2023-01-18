class ContactService < ParticipantService
 
  def create( resource )
    result = super(resource )
    if result.status != :created 
      resource.participantable = Contact.new if resource.participantable.nil?
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
  
  # def get_employer emp
  #   resource.participantable.employer = 
  # end

end