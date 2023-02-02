class UriSchemesController < SpeicherController

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:uri_scheme).permit(:scheme, :purpose, :state, :reference, :general_format, :notes)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      UriScheme.search UriScheme.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end
end
