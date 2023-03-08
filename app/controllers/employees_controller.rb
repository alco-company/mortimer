class EmployeesController < AssetsController

  layout :find_layout
  skip_before_action :set_resource, only: :export 
  skip_before_action :set_resources, only: :export 
  skip_before_action :breadcrumbs, only: [:export]


  def set_resource_class 
    @resource_class= Employee
  end

  def export
    if params[:filename]      
      t= File.open Rails.root.join("tmp",params[:filename])
      (send_data( t.read, type: 'application/pdf', :disposition => 'attachment', filename: params[:filename]) && t.close) and return
    else
      # ip = Rails.env.development? ? "10.4.3.170" : request.remote_ip
      # @resource = PunchClock.all.where(ip_addr: ip).first rescue nil
      # redirect_to root_url and return if @resource.nil?

      @from_date = Date.parse(params[:from]) rescue nil
      @to_date = Date.parse(params[:to]) rescue nil 
      @settled_at = Date.parse(params[:settled]) rescue nil 

      params[:context] = self
      if params[:instant]
        fn = Employee.print_record(params)
        if fn
          t= File.open Rails.root.join("tmp", fn)
          (send_data( t.read, type: 'application/pdf', :disposition => 'attachment', filename: "export.pdf") && t.close) and return
        end
      else
        render "export", locals: {filename: Employee.print_record(params)} and return
      end
    end
  end

  private 


    def find_layout
      return false if request.path =~ /export_selection$/
      super
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      #
      # WIP - 2022-10-12 whd
      # use case not entirely clear; what should be updated, created, and more
      #
      # if we need to set the state - to allow the employee to continue punching after a fail
      # if params[:asset][:state] != resource.state 
      #   AssetWorkTransactionService.new.create_employee_punch_transaction( resource, punch_params )
      # end
      #
      params[:asset][:assetable_attributes][:hired_at] = DateTime.parse params[:asset][:assetable_attributes][:hired_at]
      params.require(:asset).permit(:assetable_type, :name, :state, :account_id, teams: [], work_schedules: [], 
        assetable_attributes: [ :id, :pin_code, :pbx_extension, :hired_at, :job_title, :birthday, :base_salary, :norm_time, :description, :mug_shot, signed_pupils: {} ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Employee.search Employee.all, params[:q]
    end
end
