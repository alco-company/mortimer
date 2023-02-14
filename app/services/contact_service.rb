class ContactService < ParticipantService
 
  def create( resource )
    result = super(resource )
    if result.status != :created 
      resource.participantable = Contact.new if resource.participantable.nil?
    end
    result
  end
  
  def update( resource, resource_params )
    parm = resource_params
    emp = parm[:participantable_attributes].delete :employer
    result = super(resource,parm )
    if result.status != :updated
      resource.participantable = resource_class.new if resource.participantable.nil?
    else 
      result.record.participantable.update_attribute( :employer, ParticipantService.new.get_by( :name, emp, {name: emp}, Contact)) if emp
    end
    result
  end
  
  # def get_employer emp
  #   resource.participantable.employer = 
  # end

end