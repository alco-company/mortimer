class Version < ActiveRecord::Base

  def self.cleanup_older_than_60_days 
    Version.where("created_at < ?", 60.days.ago).destroy_all
  end
end
