class SuppliersController < ParticipantsController

  def set_resource_class
    @resource_class= Supplier
  end

  # def new_resource
  #   @resource = Participant.new participantable: Supplier.new
  # end

  # def resource
  #   @resource = (_id.nil? ? new_resource : Supplier.find(_id).participant )
  # end

  # def resource_class
  #   @resource_class ||= Supplier
  # end

  def lookup 
    @target=params[:target]
    @value=params[:value]
    @element_classes=params[:element_classes]
    @selected_classes=params[:selected_classes]
    respond_to do |format|
      format.turbo_stream
    end
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:participant).permit(:participantable_type, :name, :account_id, participantable_attributes: [ :id, :product_resource, :gtin_prefix ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Supplier.search Supplier.all, params[:q].downcase
    end

end
