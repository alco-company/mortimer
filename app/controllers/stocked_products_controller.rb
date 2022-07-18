class StockedProductsController < AssetsController

  def set_resource_class
    @resource_class= StockedProduct
  end
  
  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :stock_unit ] )      
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      StockedProduct.search StockedProduct.all, params[:q]
    end
end
