class CalendarsController < SpeicherController

  def edit_resource 
    @first_date = (Date.parse(params[:start_date]) rescue Date.today)
    @start_date = @first_date.at_beginning_of_month.at_beginning_of_week
    @end_date = @first_date.at_end_of_month.at_end_of_week
    @schedules = resource.work_schedules.where('events.first_occurence <= ?', @end_date).where('(events.last_occurence is null or events.last_occurence >= ?)', @start_date)
    @schedules= @schedules.select( :id, 'events.rrule').to_json

    super
  end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:calendar).permit(:name, event_attributes: [ :id, :rrule, :first_occurence, :last_occurence ])
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Service.search Service.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end
end
