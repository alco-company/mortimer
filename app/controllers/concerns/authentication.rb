module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
    before_action :current_account
    before_action :authenticate_user!
    
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :current_account

    rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_login
  end

  def authenticate_user!
    store_location
    redirect_to login_path, status: :see_other, alert: t('you_must_login_to_access_this') unless user_signed_in?
  end

  def login(user)
    reset_session
    Current.account = session[:current_account] = user.account.id
    user.regenerate_session_token
    user.update_attribute :logged_in_at, Time.current
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
    Current.account = session[:current_account] = user.account.id
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

    def redirect_to_login
      redirect_to login_path, status: :see_other, alert: t('your_credentials_dont_match')
    end

    def current_user
      # say "Current.user (session_token) #{session[:current_user_session_token]}"
      Current.user ||= set_current_user
      Current.user
    end

    def set_current_user
      if session[:current_user_session_token].present?
        User.unscoped.find_by(session_token: session[:current_user_session_token])
      elsif cookies.permanent.encrypted[:remember_token].present?
        User.unscoped.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
      end
    end

    def current_account
      Current.account ||= set_current_account
      Current.account
    end

    def set_current_account    
      say "Current.account #{session[:current_account]}"
      return Account.find( session[:current_account]) if session[:current_account].present? and !session[:current_account].nil?
      return Account.find( (session[:current_account] = Current.user.account.id) ) if Current.user and !Current.user.nil?
      (session[:current_account] = nil)
    end

    def user_signed_in?
      Current.user.present?
    end

    def user_is_admin? 
      true
    end

end