module UserInfo

  def set_user_info
    return approve_access unless user_signed_in?
    # UserInfo.speicher_user = current_user
    # UserInfo.user_account = current_user.account 
    # UserInfo.speicher_account = request.path.include?("/accounts") ? request.path.split("/")[2] : (current_user.account.id rescue nil)
  end


  def approve_access 
    ip = Rails.env.development? ? "10.4.3.170" : request.remote_ip
    UserInfo.speicher_punch_clock=ip
    speicher_punch_clock
  end

  def speicher_punch_clock
    Current.punch_clock
  end

  def self.speicher_punch_clock=(val)
    Current.punch_clock = PunchClock.all.where(ip_addr: val).first rescue nil
  end

end