class UsersController < ParticipantsController
  # skip_before_action :authenticate_user!, only: [:create, :new]
  # skip_before_action :set_resource, only: :create
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


  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  #
  def create_resource
    # @resource= User.new(resource_params)
    result = UserService.new.create resource(), resource_params
    resource= result.record
    case result.status
    when :created; user_signed_in? ? create_update_response : redirect_to( root_path, notice: t('.check_email_for_confirmation') )
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end
  end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      if params['action'] != 'create' && resource
        params[:participant][:participantable_attributes][:confirmed_at] = resource.participantable.confirmed_at if resource.participantable.confirmed?
      end
      params[:participant][:participantable_attributes][:account_id] = params[:participant][:account_id]
      params.require(:participant).permit(:participantable_type, :name, :account_id, roles: [], teams: [], participantable_attributes: [ :id, :user_name, :account_id, :email, :password, :password_confirmation, :confirmed_at, :unconfirmed_email ] )

      # case params["action"]
      # # when "create"; return create_user_params
      # when "create"; return update_user_params
      # when "update"; return update_user_params
      # end
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
      # if params[:participant][:participantable_attributes][:confirmed_at]=='0' && resource.participantable.confirmed?
      #   params[:participant][:participantable_attributes][:confirmed_at] = nil
      # else
      #   say resource.to_json 
      #   say resource.participantable.to_json
      #   unless resource.participantable.confirmed? 
      #     params[:participant][:participantable_attributes][:confirmed_at]=DateTime.current 
      #   end
      # end
      params[:participant][:participantable_attributes][:account_id] = params[:participant][:account_id]
      params.require(:participant).permit(:participantable_type, :name, :account_id, roles: [], teams: [], participantable_attributes: [ :id, :user_name, :account_id, :email, :password, :password_confirmation, :confirmed_at, :unconfirmed_email ] )
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
