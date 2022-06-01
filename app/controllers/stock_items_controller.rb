class StockItemsController < AssetsController

  def set_resource_class
    @resource_class= StockItem
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
      StockItem.search StockItem.all, params[:q]
    end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_stock_item
  #     @stock_item = StockItem.find(params[:id])
  #   end

  #   # Only allow a list of trusted parameters through.
  #   def stock_item_params
  #     params.require(:stock_item).permit(:stocked_product_id, :stock_location_id, :batch_number, :expire_at)
  #   end
end
