class LocationsController < AssetsController

  def set_resource_class
    @resource_class= Location
  end
  
  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :long_lat, :asset_requirements ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Location.search Location.all, params[:q]
    end
end
