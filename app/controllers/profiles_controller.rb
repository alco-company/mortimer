class ProfilesController < SpeicherController

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:profile).permit(:user_id, :time_zone)
    end
end
