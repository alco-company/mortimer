# frozen_string_literal: true

class Resource::InputCalendarComponent < ApplicationComponent
  def initialize(form:, field:, resource:, title:, start_date:)
    @form = form
    @field = field
    @resource = resource
    @title = title

    @week_planning = @field == :rrule
    @start_date = (start_date || Date.today).at_beginning_of_month.at_beginning_of_week
    @end_date = @start_date + 42.days
    rrulencode if @week_planning
  end

  def rrulencode 
    # @resource.rrule = @resource.rrule.split ","
  end

end
