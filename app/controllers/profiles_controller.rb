class ProfilesController < SpeicherController

  def set_resource
    @resource = Profile.find_by( user_id: _id)
    # @resource ||= (_id.nil? ? new_resource : (Profile.find_by( user_id: _id) || Profile.save(user_id: _id)))
    @resource
  end

  # The very essense of U in the CRUD - 
  # any controller not required to do special stuff
  # will inherit from this method
  # update_resource will instantiate an AbstractResourceService object
  # and call update on it, returning an instance of Result (defined on AbstractResourceService)
  def update_resource
    # Each resource could have it's own - 
    result = "#{resource_class.to_s}Service".constantize.new.update  resource(), resource_params
    resource= result.record
    case result.status
    when :updated; head 200
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end    
  end

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:profile).permit(:user_id, :time_zone, :locale, :avatar)
    end
end
