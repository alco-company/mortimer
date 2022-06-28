class TimeZonesController < ApplicationController

  def lookup 
    @resources = ActiveSupport::TimeZone.all.map{ |tz| tz.name if tz.name =~ /#{params[:q]}/i }.compact

    @target=params[:target]
    @value=params[:value]
    @element_classes=params[:element_classes]
    @selected_classes=params[:selected_classes]
    respond_to do |format|
      format.turbo_stream
    end
  end

  def index
    if params[:ids].blank?
      @resources = ActiveSupport::TimeZone.all.map{ |tz| tz.name }.compact
    else
      @resources = ActiveSupport::TimeZone.all.map{ |tz| tz.name if tz.name =~ /#{params[:ids]}/i }.compact
    end
  end


end
