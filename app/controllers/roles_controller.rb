class RolesController < SpeicherController

  def lookup 
    @target=params[:target]
    @values=params[:values].split(',')
    @element_classes=params[:element_classes]
    @selected_classes=params[:selected_classes]
    respond_to do |format|
      format.turbo_stream
    end
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    # Parameters: {"authenticity_token"=>"[FILTERED]", "role"=>{"account_id"=>"2", "name"=>"k", "context"=>"k", "role"=>{"0"=>"on", "1"=>"on", "2"=>"on", "3"=>"on", "4"=>"on", "5"=>"on", "6"=>"on", "7"=>"on", "8"=>"on"}}}
    def resource_params
      params[:role][:role] = set_role
      params.require(:role).permit(:account_id, :name, :ancestry, :context, :position, :state, :role)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Role.search Role.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end

    def set_role 
      r = []
      Role::AUTHORIZATIONS.each_with_index do |v,k|
        res = params[:role][:role][k.to_s]=='on' ? v[0] : '-'
        r.push(res) 
      end
      r.join()
    rescue
      "---------"
    end
end
