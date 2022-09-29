class PunchClock < AbstractResource
  include Assetable

  has_secure_token :access_token
  
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("assetable" deleted_at: nil)
    PunchClock.all.joins(:asset)
  end
  
end
