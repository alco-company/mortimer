class VersionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin     
      say "Running VersionJob cleanup"

      #
      # remove all versions older than 30 days
      #
      Version.cleanup_older_than_60_days

    rescue => exception
      say exception
    ensure      
      say "VersionJob done"
    end
  end
end
