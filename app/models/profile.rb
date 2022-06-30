class Profile < AbstractResource
  belongs_to :user

  validates :time_zone, presence: true, time_zone: true

  def name 
    "profile"
  end
  
  def self.default_scope
    where(deleted_at: nil)
  end

  def self.find user_id 
    p = where( user_id: user_id).first
    p.nil? ? new( user_id: user_id) : p
  end

  def combo_values_for_time_zone
    [time_zone]
  end

  def broadcast_create
  end

  def broadcast_update
  end

  def broadcast_destroy
  end
  #
  #

end
