class WorkSchedulesController < EventsController

  def set_resource_class
    @resource_class= WorkSchedule
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      set_eventable_params
      params.require(:event).permit(:name, :account_id, :eventable_type, :calendar_id, :state, :position, :rrule, 
          :first_occurence, :last_occurence, eventable_attributes: [ :id, :roll, :start_minute_string, :end_minute_string ]  )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      WorkSchedule.search WorkSchedule.all, params[:q]
    end

    # Parameters: {"authenticity_token"=>"[FILTERED]", "event"=>{"account_id"=>"1", "eventable_type"=>"WorkSchedule", "name"=>"uge 1-3", 
    #   "eventable_attributes"=>{"roll"=>"true", "start_minute"=>"07:30", "end_minute"=>"14:45"}, 
    #   "rrule"=>"[42,\"1\",\"3\",\"5\",\"6\",\"7\",\"8\",\"9\",\"10\",\"11\",\"12\",\"15\",\"16\",\"18\",\"20\",\"21\"]"}}
    def set_eventable_params
      params[:event][:rrule] = rrulify
    end

    def rrulify 
      JSON.parse( params[:event][:rrule] ).join ","
    end
end
