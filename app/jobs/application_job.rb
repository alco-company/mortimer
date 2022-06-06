class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  def say msg 
    Rails.logger.info "----------------------------------------------------------------------"
    Rails.logger.info msg
    Rails.logger.info "----------------------------------------------------------------------"
  end
  
end
