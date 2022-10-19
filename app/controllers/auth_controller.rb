
# require 'microsoft_graph_auth'
require 'oauth2'

class AuthController < ApplicationController
  before_action :redirect_if_authenticated, only: :callback
  skip_before_action :authenticate_user!, only: :callback


  def callback

    # Access the authentication hash for omniauth
    data = request.env['omniauth.auth']

    @user = User.unscoped.find_by(email: data['extra']['raw_info']['mail'])
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: raw_t('.request_confirmation_email')
      else
        after_login_path = session[:user_return_to] || root_path
        login @user

        # Save the data in the session
        save_in_session data

        redirect_to after_login_path, notice: raw_t('.signed_in')
      end
    else
      flash.now[:alert] = raw_t('.incorrect_name_password')
      redirect_to root_path, notice: raw_t('.no_azure_verified_login')
    end

  end

  def set_user
    @user_name = user_name
    @user_email = user_email
  end

  def save_in_session(auth_hash)
    # Save the token info
    session[:graph_token_hash] = auth_hash[:credentials]
    # Save the user's display name
    session[:user_name] = auth_hash.dig(:extra, :raw_info, :displayName)
    # Save the user's email address
    # Use the mail field first. If that's empty, fall back on
    # userPrincipalName
    session[:user_email] = auth_hash.dig(:extra, :raw_info, :mail) ||
    auth_hash.dig(:extra, :raw_info, :userPrincipalName)
    # Save the user's time zone
    session[:user_timezone] = auth_hash.dig(:extra, :raw_info, :mailboxSettings, :timeZone)
    debugger
  end

  def user_name
    session[:user_name]
  end

  def user_email
    session[:user_email]
  end

  def user_timezone
    session[:user_timezone]
  end

  def access_token
    token_hash = session[:graph_token_hash]
    return if token_hash.nil?

    # Get the expiry time - 5 minutes
    expiry = Time.at(token_hash[:expires_at] - 300)

    if Time.now > expiry
      # Token expired, refresh
      new_hash = refresh_tokens token_hash
      new_hash[:token]
    else
      token_hash[:token]
    end
  end

  def refresh_tokens(token_hash)
    oauth_strategy = OmniAuth::Strategies::MicrosoftGraphAuth.new(
      nil, Current.account.app_id, Current.account.app_secret
    )

    token = OAuth2::AccessToken.new(
      oauth_strategy.client, token_hash[:token],
      refresh_token: token_hash[:refresh_token]
    )

    # Refresh the tokens
    new_tokens = token.refresh!.to_hash.slice(:access_token, :refresh_token, :expires_at)

    # Rename token key
    new_tokens[:token] = new_tokens.delete :access_token

    # Store the new hash
    session[:graph_token_hash] = new_tokens
  end

end
