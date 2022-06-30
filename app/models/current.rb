class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user
  attribute :request_id, :user_agent, :ip_address, :variant
  attribute :punch_clock
  attribute :errors

  resets { Time.zone = nil }
  
  def user=(user)
    super
    # self.account = user.account - impersonate user will not work 
    Time.zone = user.time_zone rescue 'UTC'
  end

end