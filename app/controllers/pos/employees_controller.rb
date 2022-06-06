module Pos
  class EmployeesController < AssetsController

    layout :find_layout
    skip_before_action :current_user, only: :show
    skip_before_action :current_account, only: :show
    skip_before_action :authenticate_user!, only: :show

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
      @resource = (_id.nil? ? new_resource : Employee.find(_id).asset )
    end

    def resource_class
      @resource_class ||= Employee
    end

    def show 
      redirect_to root_path and return unless token_approved
    end

    private 


      def find_layout
        return false if request.path =~ /export_selection$/
        return "time_pos" if params[:action] == "show"
        super
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def resource_params
        params[:asset][:assetable_attributes][:hired_at] = DateTime.parse params[:asset][:assetable_attributes][:hired_at]
        params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :hired_at ] )
      end

      #
      # implement on every controller where search makes sense
      # geet's called from resource_control.rb 
      #
      def find_resources_queried options
        Employee.search Employee.all, params[:q]
      end

      def token_approved
        resource.assetable.access_token == params[:api_key]
      end
  

  end
end