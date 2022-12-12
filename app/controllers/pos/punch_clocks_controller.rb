module Pos
  class PunchClocksController < AssetsController

    layout :find_layout
    skip_before_action :current_user, only: [:index, :show, :punch, :search]
    skip_before_action :breadcrumbs
    skip_before_action :current_account, only: [:index, :show, :punch, :search]
    skip_before_action :authenticate_user!, only: [:index, :show, :punch, :search]

    #
    # we have to 'redefine' the resource calls to provide the proper 
    # form and model insert,update pattern
    # this is less than optimal :(
    # walther 22/3/2022
    #
    def new_resource
      @resource = Asset.new assetable: PunchClock.new
    end

    def resource
      @resource ||= (_id.nil? ? new_resource : Asset.unscoped.where( assetable: PunchClock.unscoped.find(_id)).first )
    end

    def resource_class
      @resource_class ||= PunchClock
    end
    
    def show 
      redirect_to root_path and return unless token_approved
    end

    def search
      @resources=Pupil.search_by_model_fields Pupil.all, params[:q]
    end
    
    #
    # Parameters: { "asset_work_transaction"=>{"punched_at"=>"2022-10-13T07:48:37.239Z", "state"=>"IN", 
    #               "punched_pupils"=>{"pupil_2"=>"on", "pupil_6"=>"on"}}, "api_key"=>"[FILTERED]", "id"=>"2", "employee"=>{}}
    def punch 
      head 301 and return unless token_approved
      event = AssetWorkTransactionService.new.create_employee_punch_transaction( resource, resource_params )
      if event && (['OUT','SICK','BREAK'].include? resource_params['state']) 
        ev = PupilTransactionService.new.close_active_pupils( resource, event, resource_params ) if resource_params[:punched_pupils]
      end
      head 200
    end

    private 


      def find_layout
        return false if request.path =~ /export_selection$/
        return "time_pos" if params[:action] == "show"
        super
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def resource_params
        params["asset_work_transaction"]["ip_addr"] = request.remote_ip
        params["asset_work_transaction"]["employee_asset_id"] = resource.id
        params["asset_work_transaction"]["punch_asset_id"] = resource.id # the user's own device
        params.require(:asset_work_transaction).permit(:punched_at, :state, :ip_addr, :punch_asset_id, :p_time, :substitute, :employee_asset_id, punched_pupils: {} )
      end

      #
      # implement on every controller where search makes sense
      # geet's called from resource_control.rb 
      #
      def find_resources_queried options={}
        PunchClock.search PunchClock.all, params[:q]
      end

      def token_approved
        Current.account = resource.account
        Current.user ||= Current.account.users.first
        resource.assetable.access_token == params[:api_key]
      end
  

  end
end