class BackgroundProcessingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin     
      BackgroundJob.prepare
    rescue => exception
      say exception
    ensure      
    end
  end
end
