class ProfilesController < SpeicherController

  def set_resource
    @resource = Profile.find_by( user_id: _id)
    # @resource ||= (_id.nil? ? new_resource : (Profile.find_by( user_id: _id) || Profile.save(user_id: _id)))
    @resource
  end

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:profile).permit(:user_id, :time_zone, :avatar)
    end
end
