class TeamsController < ParticipantsController

  def set_resource_class
    @resource_class= Team
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params[:participant][:participantable_attributes] ||= {}
      # params[:participant][:participantable_attributes][:task_id] = 0
      params.require(:participant).permit(:participantable_type, :name, :account_id, roles: [], work_schedules: [], participantable_attributes: [ :id, :task_id ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Team.search Team.all, params[:q].downcase
    end

end
