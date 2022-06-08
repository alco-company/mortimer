class StockItemTransactionsController < EventsController

  def set_resource_class
    @resource_class= StockItemTransaction
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
      StockItemTransaction.search StockItemTransaction.all, params[:q]
    end

    #
    # delete_it gets called from the abstract_resources_controller
    # and overwrites the events_controller -
    # in order to either add or subtract quantity from
    # the stock_item
    def delete_it

      case resource.state
      when "RECEIVE"; resource.eventable.stock_item.update_attribute :quantity, resource.eventable.stock_item.quantity - resource.eventable.quantity
      when "SHIP","SCRAP"; resource.eventable.stock_item.update_attribute :quantity, resource.eventable.stock_item.quantity + resource.eventable.quantity
      # when "INVENTORY"; 
      end

      return resource.update(deleted_at: DateTime.now) if params[:purge].blank?
      resource.destroy
    end
  

end
