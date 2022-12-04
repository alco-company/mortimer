class BackgroundJobsController < SpeicherController

  def set_resource_class
    @resource_class= BackgroundJob
  end

  def delete_run_job
    ss = Sidekiq::ScheduledSet.new
    job = ss.find_job resource.job_id
    job.delete if job
    user = Current.user || User.unscoped.find( resource.user_id)
    resource.job_done
    render turbo_stream: turbo_stream.replace( "background_job_#{resource.id}", partial: "background_jobs/background_job", locals: { resource: resource, user: user } )  
  end
  
  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    # adding a small hack to get the BackgroundProcessingJob to re-evaluate the job.schedule
    # by setting the job_id to nil
    #
    def resource_params
      params[:background_job][:job_id] = nil if params[:action] == "update"
      params.require(:background_job).permit(:account_id, :user_id, :klass, :params, :active, :schedule, :next_run_at, :job_id)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      BackgroundJob.search BackgroundJob.all, params[:q]
    end
end
