class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  skip_before_action :authenticate_user!, except: :destroy

  def create
    @user = User.unscoped.authenticate_by(user_name: params[:user][:user_name], password: params[:user][:password])
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: raw_t('.request_confirmation_email')
      else
        after_login_path = session[:user_return_to] || root_path
        Current.account = @user.account
        login @user
        remember(@user) if params[:user][:remember_me] == "1"
        redirect_to after_login_path, notice: raw_t('.signed_in')
      end
    else
      flash.now[:alert] = raw_t('.incorrect_name_password')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    say (current_user.participant.to_json rescue "N/A")
    forget(current_user)
    logout
    redirect_to root_path, status: :see_other, notice: raw_t('.signed_out')
  end

  def new
  end

end
