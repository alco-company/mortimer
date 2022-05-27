require 'active_support/concern'

module ClientControl
  extend ActiveSupport::Concern


  included do

    before_action :evaluate_client_platform

  end

  def evaluate_client_platform
    case request.user_agent
    when /iPad/
      request.variant = :tablet
    when /iPhone|Android/ # far from complete. just for the sake of example
      request.variant = :phone
    end  
    if browser.device.tablet?
      request.variant = :tablet
    elsif browser.device.mobile?
      request.variant = :phone
    end

  end

  # respond_to do |format|
  #   format.html do |html|
  #     html.tablet # renders app/views/projects/show.html+tablet.erb
  #     html.phone { extra_setup_if_needs; render ... }
  #   end
  # end  

end