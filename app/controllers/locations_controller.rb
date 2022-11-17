#
# Locations are placed of interest to an organisation
# either because they represent a value as a source
# of wealth - turning out products/services - or
# because they generate costs (hopefully because they
# support other locations that generate wealth)
#
# examples of locations are
#
# - factories
# - assembly lines
# - workshops
# - workbenches
#
# Locations are hierachically organised, meaning that
# aa workbench sits in a workshop along an assembly line
# in a factory
#
# The main difference between locations and stock_locations
# is the nature of the location. Stock locations are passive
# stores where products are kept - either raw material, 
# work in progress, or finished goods
# Locations on the other hand are active entities where 
# cost is incurred in some variable way relative to the 
# flow/consumption of assets (product,machine,manpower,money)
#
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
