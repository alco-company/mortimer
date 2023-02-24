module Pos
  class PunchClocksController < AssetsController

    layout :find_layout
    skip_before_action :current_user, only: [ :show, :punch, :search ]
    skip_before_action :breadcrumbs
    skip_before_action :current_account, only: [ :show, :punch, :search ]
    skip_before_action :authenticate_user!, only: [ :show, :punch, :search ]

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
      @resource ||= (_id.nil? ? new_resource : Asset.unscoped.where( assetable: PunchClock.unscoped.find(_id)).first)
    end

    def resource_class
      @resource_class ||= PunchClock
    end

    # http://localhost:3000/pos/punch_clocks/2?api_key=X5mqvD4ythzGVoETDvjEWHvL
    def show 
      redirect_to root_path and return unless token_approved
      @employee = nil
    end

    # {"apikey"=>"X5mqvD4ythzGVoETDvjEWHvL", "q"=>"1234", "controller"=>"pos/punch_clocks", "action"=>"search"}
    def search
      redirect_to root_path and return unless token_approved
      @employee=Employee.find_by pin_code: params[:q]
      # render turbo_stream: turbo_stream.replace( "employee_punch_clock_info", partial: 'employee_info' ), locals: { resource: resource, employee: @employee }
    end
    
    #
    # Parameters:  { "asset_work_transaction"=>{
    #   "punched_at"=>"2023-02-24T12:14:32.771Z", "state"=>"IN", "employee_id"=>"60"}, "api_key"=>"[FILTERED]", "id"=>"2", "punch_clock"=>{}
    # }
    #               
    def punch 
      head 301 and return unless token_approved
      employee_asset = Employee.find( resource_params[:employee_id]).asset
      event = AssetWorkTransactionService.new.create_employee_punch_transaction( employee_asset, resource_params )
      if event && (['OUT','SICK','BREAK','FREE'].include? resource_params['state']) 
        AssetWorkdaySumService.new.update_workday_sum( employee_asset, event )
        ev = PupilTransactionService.new.close_active_pupils( employee_asset, event, resource_params ) if resource_params[:punched_pupils]
      end
      head 200
    end

    private 


      def find_layout
        return false if request.path =~ /export_selection$/
        return "time_pos" if request.path =~ /search$/
        return "time_pos" if params[:action] == "show"
        super
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def resource_params
        params["asset_work_transaction"]["ip_addr"] = request.remote_ip
        params["asset_work_transaction"]["employee_asset_id"] = resource.id
        params["asset_work_transaction"]["punch_asset_id"] = resource.id # the user's own device
        params.require(:asset_work_transaction).permit(:punched_at, :state, :employee_id, :ip_addr, :punch_asset_id, :p_time, :substitute, :employee_asset_id, punched_pupils: {} )
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
        return false unless resource.assetable.access_token == params[:api_key]
        Current.user ||= Current.account.users.first
        true
      end
  

  end
end