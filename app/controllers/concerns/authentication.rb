module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
    before_action :current_account
    before_action :authenticate_user!
    
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :current_account
  end

  def authenticate_user!
    store_location
    redirect_to login_path, alert: t('you_must_login_to_access_this') unless user_signed_in?
  end

  def login(user)
    reset_session
    user.regenerate_session_token
    user.update_attribute :logged_in_at, Time.now
    session[:current_user_session_token] = user.reload.session_token
  end
  
  def logout
    user = current_user
    reset_session
    user.update_attribute :logged_in_at, nil
    user.regenerate_session_token
  end

  def redirect_if_authenticated
    if user_signed_in?
      return if user_is_admin?
      redirect_to root_path, alert: "You are already logged in." 
    end
  end

  def forget(user)
    cookies.delete :remember_token
    user.regenerate_remember_token
  end  

  def remember(user)
    user.regenerate_remember_token
    cookies.permanent.encrypted[:remember_token] = user.remember_token
  end

  def store_location
    session[:user_return_to] = request.original_url if request.get? && (request.local? || Rails.env.development?)
  end

  private

  def current_user
    Current.user ||= if session[:current_user_session_token].present?
      User.unscoped.find_by(session_token: session[:current_user_session_token])
    elsif cookies.permanent.encrypted[:remember_token].present?
      User.unscoped.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
    end
  end

  def current_account
    Current.account ||= if !session[:current_account].nil?
      (Account.find session[:current_account] rescue nil)
    else
      (current_user.account rescue nil)
    end
  end

  def user_signed_in?
    Current.user.present?
  end

  def user_is_admin? 
    true
  end

end