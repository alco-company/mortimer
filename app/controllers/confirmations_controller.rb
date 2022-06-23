class ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :evaluate_client_platform

  def new
    @user = User.new
    render "new"
  end
  
  def create
    users = User.unscoped.find_by(email: params[:user][:email].downcase)
    flash[:notice] = []
    flash[:warning] = []
    dest = root_path
    if [users].compact.any?
      [users].compact.each do |user|
        if user.unconfirmed?
          user.send_confirmation_email!
          flash[:notice] << "%s %s" % [ raw_t('.we_sent_a_confirmation_email'), user.email]
          dest = login_path
        else
          flash[:warning] << "%s %s" % [ raw_t('.email_confirmed_already'), user.email ]
          dest = login_path 
        end
      end
      redirect_to dest
    else
      redirect_to new_password_path, alert: raw_t('.no_email_found') + params[:user][:email].downcase
    end
  end

  def edit
    @user = User.unscoped.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present? && @user.unconfirmed_or_reconfirming?
      if @user.confirm!
        login @user
        redirect_to root_path, notice: raw_t('.email_confirmed')
      else
        redirect_to new_confirmation_path, alert: raw_t('.something_went_wrong')
      end
    else
      redirect_to new_confirmation_path, alert: raw_t('.invalid_token')
    end
  end

end
