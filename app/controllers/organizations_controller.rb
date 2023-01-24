class OrganizationsController < ParticipantsController

  def set_resource_class
    @resource_class= Organization
  end

  def lookup_resources 
    @target=params[:target]
    @value=params[:value]
    @element_classes=params[:element_classes]
    @selected_classes=params[:selected_classes]
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:participant).permit(:participantable_type, :name, :account_id, participantable_attributes: [ :id, :cvr_number, :product_resource, :gtin_prefix ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Organization.search Organization.all, params[:q].downcase
    end

end
