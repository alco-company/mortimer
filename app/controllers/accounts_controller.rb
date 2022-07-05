class AccountsController < SpeicherController

  def impersonate
    Current.account = Account.find params[:account_id]
    session[:current_account] = Current.account.id
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:account).permit(:name, :logo, signed_services: {})
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Account.search Account.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end
end
