class UserService < ParticipantService
  def create( resource, resource_params )
    result = super(resource)
    if result.status != :created 
      resource.participantable = resource_class.new if resource.participantable.nil?
    else
      update_roles_teams result, resource_params
      resource.participantable.confirm! if resource_params[:participantable_attributes][:confirmed_at] == '1'
      Profile.create user: result.record.participantable, time_zone: 'UTC', locale: I18n.default_locale
      result.record.participantable.send_confirmation_email! unless result.record.participantable.confirmed?
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

  def delete( resource, resource_params )
    
    name = resource.participantable.user_name

    # anonymize user's name
    while User.find_by( user_name: name) do
      name = SecureRandom.hex
    end
    resource.participantable.update_attribute :user_name, name
    super(resource, resource_params)

  end



  def update_roles_teams result, params 
    result.record.roles= params["roles"] 
    result.record.teams= params["teams"] 
    result.record.save
  end
end
