class EquipmentController < AssetsController

  layout :find_layout

  def set_resource_class 
    @resource_class= Equipment
  end

  def book
    render turbo_stream: turbo_stream.replace( resource_form, partial: 'book', locals: { resource: resource } )
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
      # if we need to set the state - to allow the Equipment to continue punching after a fail
      # if params[:asset][:state] != resource.state 
      #   AssetWorkTransactionService.new.create_Equipment_punch_transaction( resource, punch_params )
      # end
      #
      # params[:asset][:assetable_attributes][:purchased_at] = DateTime.parse params[:asset][:assetable_attributes][:purchased_at]
      params.require(:asset).permit(:assetable_type, :name, :state, :account_id, work_schedules: [], 
        assetable_attributes: [ :id, :access_token, :brand, :model, :location_id, :organization_id, :purchased_at, :purchase_price, :residual_value, :warranty_ends_at, :serial_number, :description ] )
    end

      


    # def punch_params
    #   parms = {
    #     asset_work_transaction: {
    #       ip_addr: request.remote_ip,
    #       Equipment_asset_id: resource.id,
    #       punched_at: DateTime.now,
    #       state: params[:asset][:state],
    #       force: true
    #     }
    #   }
    #   ActionController::Parameters.new(parms).require(:asset_work_transaction).permit(:punched_at, :state, :ip_addr, :punch_asset_id, :Equipment_asset_id, punched_pupils: {} )
    # end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Equipment.search Equipment.all, params[:q]
    end
end
