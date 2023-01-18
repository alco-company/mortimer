class AssetWorkTransactionsController < EventsController

  def set_resource_class
    @resource_class= AssetWorkTransaction
  end


  def new_resource 
    Event.new eventable: resource_class.new
  end


  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.permit(:stock_id, :id)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      AssetWorkTransaction.search AssetWorkTransaction.all, params[:q]
    end

end
