# Parameters: {
#   "authenticity_token"=>"[FILTERED]", 
#   "event"=>{
#     "account_id"=>"1", "eventable_type"=>"Task", "name"=>"3", 
#     "eventable_attributes"=>{
#       "duration"=>"3"
#     }, 
#     "assignments_attributes"=>{
#       "0"=>{
#         "assignable_type"=>"Employee", "assignable_id"=>"55", "assignable_role"=>"owner"
#       }
#     }
#   }
# }

class TasksController < EventsController

  def set_resource_class
    @resource_class= Task
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:event).permit(:name, :account_id, :eventable_type, eventable_attributes: [ :id, :duration ], assignments_attributes: [ :id, :assignable_id, :assignable_type, :assignable_role, :_destroy ]  )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Task.search Task.all, params[:q]
    end
end
