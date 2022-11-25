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
    #
    # some urls are providing api_key and not a user in particular,
    # in which case we'll use first account 'user' which should always be set up
    # when creating an account
    head 301 and return if api_params_present? and !token_approved
    #
    redirect_to login_path, status: :see_other, alert: t('you_must_login_to_access_this') unless user_signed_in?
  end

  def login(user)
    reset_session
    current_user user
    set_current_account
    # Current.account = session[:current_account] = user.account.id
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

    def current_user usr=nil
      # say "Current.user (session_token) #{session[:current_user_session_token]}"
      Current.user ||= set_current_user(usr)
      Current.user
    end

    def set_current_user usr=nil
      return usr unless usr.nil?
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
      return Current.account = Account.find( (session[:current_account] = Current.user.account.id) ) if Current.user and !Current.user.nil?
      (session[:current_account] = nil)
    end

    def user_signed_in?
      Current.user.present?
    end

    def user_is_admin? 
      true
    end

    #
    # we may see urls like
    # "/locations?ids=3&api_key=[FILTERED]&api_class=Employee" 
    # in which case we can conclude that api_params are present
    #
    def api_params_present? 
      params.include? :api_key and params.include? :api_class
    end

    #
    # using an api_key and an api_class
    # may allow us to prove a token true
    # and set an appropriate account/user
    #
    def token_approved 
      res = params[:api_class].constantize.unscoped.find_by access_token: params[:api_key]
      return false if res.nil?
      Current.account = owing_account res
      Current.user = Current.account.users.first rescue nil
      true
    rescue
      say "authentication#token_approved failed!!!!!"
      true
    end

    #
    # we may get called with a variaty of entities
    #
    def owing_account res 
      case true
      when res.respond_to?(:account_id)
        account = Account.unscoped.find res.account_id
      when res.class.respond_to?(:delegated_from)
        case res.class.delegated_from.to_s
        when 'Asset';       account = Asset.unscoped.find_by( assetable_id: res.id, assetable_type: params[:api_class]).account
        when 'Event';       account = Event.unscoped.find_by( eventable_id: res.id, eventable_type: params[:api_class]).account
        when 'Participant'; account = Participant.unscoped.find_by( participantable_id: res.id, participantable_type: params[:api_class]).account
        # when 'Message';   account = Message.unscoped.find_by( messageable_id: res.id, messageable_type: params[:api_class]).account
        end
      end
      account
    rescue
      say "authentication#owing_account failed!!!!!"
      nil
    end

end
