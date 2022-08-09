class PupilsController < AssetsController

  def set_resource_class 
    @resource_class= Pupil
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      # params[:asset][:assetable_attributes][:hired_at] = DateTime.parse params[:asset][:assetable_attributes][:hired_at]
      params.require(:asset).permit(:assetable_type, :name, :account_id, :state, assetable_attributes: [ :id, :time_spent_minutes, :location ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Pupil.search Pupil.all, params[:q]
    end
end
