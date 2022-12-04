module BackgroundJobsHelper
  #
  # show a button if job has an id
  # signifying that it has been scheduled to run
  def delete_job resource, user=nil
    return "" if resource.job_id.blank?
    I18n.locale = user.profile.locale rescue I18n.default_locale
    button_to t(".delete_run_job"), delete_run_job_background_job_url(resource), class: "inline-flex items-center rounded-full bg-pink-100 px-3 py-0.5 text-sm font-medium text-pink-800"
  end
end
