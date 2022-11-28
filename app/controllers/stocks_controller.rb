class StocksController < AssetsController

  def set_resource_class
    @resource_class= Stock
  end
  
  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      set_assetables params
      # , :access_token not permitted - 'cause it's a secure_token
      params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :last_heart_beat_at, :created_at, :access_token ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Stock.search Stock.all, params[:q]
    end


    def set_assetables params
      # params[:asset][:assetable_attributes].delete(:access_token)
      if params[:asset][:assetable_attributes].nil?
        params[:asset][:assetable_attributes] = { created_at: DateTime.current }
      # else
      #   params[:asset][:assetable_attributes][:access_token] = "has to be set - otherwise assetable will not be created/updated"
      end      
    end
end
