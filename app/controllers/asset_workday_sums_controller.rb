class AssetWorkdaySumsController < AbstractResourcesController

  private
    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:asset_workday_sum).permit(:account_id, :asset_id, :work_date, :work_minutes, :break_minutes, :ot1_minutes, :ot2_minutes, :sick_minutes, :free_minutes, :deleted_at)
    end
end
