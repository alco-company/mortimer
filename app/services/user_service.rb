class UserService < ParticipantService
  def create( resource, resource_params, resource_class )
    result = super(resource, resource_class)
    if result.status != :created 
      resource.participantable = resource_class.new if resource.participantable.nil?
    else
      update_roles_teams result, resource_params
      resource.participantable.confirm! if resource_params[:participantable_attributes][:confirmed_at] == '1'
      Profile.create user: result.record.participantable, time_zone: 'UTC'
      result.record.participantable.send_confirmation_email! unless result.record.participantable.confirmed?
    end
    result
  end

  def update( resource, resource_params, resource_class )
    result = super(resource,resource_params)
    if result.status != :updated
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end

  def update_roles_teams result, params 
    result.record.roles= params["roles"] 
    result.record.teams= params["teams"] 
    result.record.save
  end
end
