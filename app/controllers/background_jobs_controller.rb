class BackgroundJobsController < SpeicherController

  def set_resource_class
    @resource_class= BackgroundJob
  end
  
  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:background_job).permit(:account_id, :execute_at, :work, :params, :job_id)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      BackgroundJob.search BackgroundJob.all, params[:q]
    end
end
