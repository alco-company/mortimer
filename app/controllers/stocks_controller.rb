class StocksController < AssetsController

  def set_resource_class
    @resource_class= Stock
  end
  
  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      # params[:asset][:assetable_attributes].delete(:access_token)
      params[:asset][:assetable_attributes] = {access_token: "-"}
      params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :last_heart_beat_at ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Stock.search Stock.all, params[:q]
    end
end
