class BackgroundProcessingJob < ApplicationJob
  queue_as :default

  #
  # prepare all the background_jobs
  # as the last action - prepare this job to run once again
  # in 5 min
  #
  def perform(*args)
    begin     
      BackgroundJob.prepare
    rescue => exception
      say exception
    ensure      
    end
  end
end
