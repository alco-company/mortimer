class StockLocationsController < AssetsController

  def set_new 
    @resource.assetable.stock = Stock.find params[:stock_id] rescue nil
  end
  
  def set_resource_class
    @resource_class= StockLocation
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :stock_id, :location_barcode, :open_shelf, :shelf_size ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      StockLocation.search StockLocation.all, params[:q]
    end

end
