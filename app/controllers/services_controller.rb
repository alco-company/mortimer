class ServicesController < SpeicherController

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:service).permit(:name,:menu_label,:index_url,:state,:service_model,:service_group,:menu_icon)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Service.search Service.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end
end
