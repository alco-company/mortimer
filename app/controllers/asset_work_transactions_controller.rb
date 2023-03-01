class AssetWorkTransactionsController < EventsController

  def set_resource_class
    @resource_class= AssetWorkTransaction
  end

  def new_resource 
    punch_asset_ip_addr = request.remote_ip
    if parent?
      asset = parent.asset
    else
      asset = nil
    end
    Event.new name: 'AWT', eventable: resource_class.new( asset: asset, punch_asset_ip_addr: punch_asset_ip_addr )
  end

  def create_resource
    result = AssetWorkTransactionService.new.create_employee_transaction( resource.eventable.asset, resource_params )
    case result.status
    when :created
      if (['OUT','SICK','BREAK','FREE'].include? resource_params['state'])
        srv = resource.account.system_parameters_include("calc_asset_workday_sum") || "AssetWorkdaySumService"
        srv.classify.constantize.new.update_workday_sum( resource, result.record )
        ev = PupilTransactionService.new.close_active_pupils( resource, result.record, resource_params ) 
      end
      create_update_response
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end
  end
  
  def update_resource
    result = "#{resource_class.to_s}Service".constantize.new.update resource(), resource_params
    resource= result.record
    case result.status
    when :updated
      if (['OUT','SICK','BREAK','FREE'].include? resource_params['state'])
        srv = resource.account.system_parameters_include("calc_asset_workday_sum") || "AssetWorkdaySumService"
        srv.classify.constantize.new.update_workday_sum( resource, result.record )
        ev = PupilTransactionService.new.close_active_pupils( resource, result.record, resource_params ) 
      end
      create_update_response
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end    
  end


  private 

    #
    # id <- eventable id
    # employee_id <- assetable id
    #
    # Never trust parameters from the scary internet, only allow the white list through.
    # Parameters: {
    #   "authenticity_token"=>"[FILTERED]", 
    #   "event"=>{
    #     "account_id"=>"3", 
    #     "eventable_type"=>"AssetWorkTransaction", 
    #     "state"=>"IN",
    #     "eventable_attributes"=>{
    #       "punched_at"=>"2022-10-19T11:26", "reason"=>"",  "id"=>"34"
    #     }
    #   }, 
    #   "employee_id"=>"2", 
    #   "id"=>"34"
    # }
    def resource_params
      params.require(:event).permit(:account_id, :state, :eventable_type, eventable_attributes: [ :id, :name, :punch_asset_ip_addr, :punched_at, :reason ])
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      AssetWorkTransaction.search AssetWorkTransaction.all, params[:q]
    end

end
