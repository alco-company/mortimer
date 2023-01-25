class AssetWorkdaySumsController < SpeicherController

  def set_resource_class
    @resource_class= AssetWorkdaySum
  end

  private
    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:asset_workday_sum).permit(:account_id, :asset_id, :work_date, :work_minutes, :break_minutes, :ot1_minutes, :ot2_minutes, :sick_minutes, :free_minutes, :deleted_at)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      AssetWorkdaySum.search AssetWorkdaySum.all, params[:q].downcase
    end

end
