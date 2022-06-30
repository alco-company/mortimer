class UsersController < ParticipantsController
  # skip_before_action :authenticate_user!, only: [:create, :new]
  skip_before_action :set_resource, only: :create
  skip_before_action :breadcrumbs, only: :create
  skip_before_action :set_ancestry, only: :create
  before_action :redirect_if_authenticated, only: [:create, :new]
  
  def set_resource_class
    @resource_class= User
  end

  # def new
  #   # @account = current_user.account
  #   @user = User.new
  # end
  
  
  def sign_up
    @account = Account.new
    @user = User.new
  end
  
  def create
    @user = User.new(create_user_params)
    profile = Profile.create user: @user, time_zone: 'UTC'
    @user.account = current_account
    resource= Participant.new account: current_account, name: @user.user_name, participantable: @user
    if resource.valid?
      resource.save
      resource.participantable.send_confirmation_email! unless resource.participantable.confirmed? # params[:user][:confirmed_at]
      if user_signed_in? # and user_is_admin?
        head :ok
      else
        unless user_signed_in?
          redirect_to root_path, notice: t('.check_email_for_confirmation')
        end
      end
    else
      Current.errors = resource.errors
      render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      say "[users_controller] Errors: #{Current.errors.to_json}"
    end
  end

  def delete_it
    name = resource.participantable.user_name
    while User.find_by( user_name: name) do
      name = SecureRandom.hex
    end
    if params[:purge].blank?
      resource.participantable.update user_name: name
      return resource.update(deleted_at: DateTime.current)
    else
      resource.destroy
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      update_user_params
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      User.search User.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end

    def create_user_params
      set_confirmed_param.require(:user).permit(:user_name, :email, :password, :password_confirmation, :confirmed_at)
    end

    # { "authenticity_token"=>"[FILTERED]", "participant"=>{
    #   "account_id"=>"1", "participantable_type"=>"User", "name"=>"Walther H Diechmann", "participantable_attributes"=>{
    #     "user_name"=>"Walther", "email"=>"walther@diechmann.net", "confirmed_at"=>"1", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "id"=>"1"}
    #   }, "id"=>"1"
    # }
    #
    def update_user_params
      if params[:participant][:participantable_attributes][:confirmed_at]=='0'
        params[:participant][:participantable_attributes][:confirmed_at] = nil
      else
        say resource.to_json 
        say resource.participantable.to_json
        unless resource.participantable.confirmed? 
          params[:participant][:participantable_attributes][:confirmed_at]=DateTime.current 
        end
      end
      params.require(:participant).permit(:participantable_type, :name, :account_id, roles: [], teams: [], participantable_attributes: [ :id, :user_name, :email, :password, :password_confirmation, :confirmed_at, :unconfirmed_email ] )
      # set_confirmed_param.require(:user).permit(:user_name, :email, :password, :password_confirmation, :confirmed_at, :unconfirmed_email)
    end

    def set_confirmed_param
      pm = params[:participant][:participantable_attributes]
      params = ActionController::Parameters.new(user: {
        user_name: pm[:user_name],
        email: pm[:email],
        password: pm[:password],
        password_confirmation: pm[:password_confirmation],
        confirmed_at: pm[:confirmed_at] == "0" ? nil : DateTime.current 
      })
    end

end
