module Pos
  class EmployeesController < AssetsController

    layout :find_layout
    skip_before_action :current_user, only: [:index, :show, :punch]
    skip_before_action :breadcrumbs
    skip_before_action :current_account, only: [:index, :show, :punch]
    skip_before_action :authenticate_user!, only: [:index, :show, :punch]

    def export
      if params[:filename]
        t= File.open Rails.root.join("tmp",params[:filename])
        (send_data( t.read, type: 'application/pdf', :disposition => 'attachment', filename: params[:filename]) && t.close) and return
      else
        ip = Rails.env.development? ? "10.4.3.170" : request.remote_ip
        @resource = PunchClock.all.where(ip_addr: ip).first rescue nil
        redirect_to root_url and return if @resource.nil?

        @from_date = Date.parse(params[:from]) rescue nil
        @to_date = Date.parse(params[:to]) rescue nil 
        @settled_at = Date.parse(params[:settled]) rescue nil 

        params[:context] = self
        params[:speicher_account] = Account.current
        render "export", locals: {filename: Employee.print_record(params)} and return
      end
    end

    #
    # we have to 'redefine' the resource calls to provide the proper 
    # form and model insert,update pattern
    # this is less than optimal :(
    # walther 22/3/2022
    #
    def new_resource
      @resource = Asset.new assetable: Employee.new
    end

    def resource
      @resource ||= (_id.nil? ? new_resource : Asset.unscoped.where( assetable: Employee.unscoped.find(_id)).first )
    end

    def resource_class
      @resource_class ||= Employee
    end

    def index 
      _id= params[:id]
      resource 
      redirect_to root_path and return unless token_approved
      @resources = find_resources_queried {}
      render layout: 'naked'
    end
    
    def show 
      redirect_to root_path and return unless token_approved
    end
    
    def punch 
      Rails.logger.info resource_params
      head 301 and return unless token_approved
      res1 = AssetWorkTransactionService.new.create_employee_punch_transaction( resource, resource_params )
      if res1
         res2 = PupilTransactionService.new.create_pupil_transaction( resource, resource_params )
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
        params.require(:asset_work_transaction).permit(:punched_at, :state, :ip_addr, :punch_asset_id, :employee_asset_id, punched_pupils: {} )
      end

      #
      # implement on every controller where search makes sense
      # geet's called from resource_control.rb 
      #
      def find_resources_queried options={}
        Employee.search Employee.all, params[:q]
      end

      def token_approved
        Current.account = resource.account
        resource.assetable.access_token == params[:api_key]
      end
  

  end
end