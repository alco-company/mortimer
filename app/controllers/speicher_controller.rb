class SpeicherController < AbstractResourcesController
  #
  # make it easy to do pagination of resources
  #
  include Pagy::Backend

  #
  # set the layout used for this action/view
  #
  # layout :find_layout

  #
  # set_fulltext allows for fulltext searching on all resources
  # TODO find a way to do fulltext search across all resources - using the versions table perhaps!
  #
  after_action :set_fulltext, only: %i[create update]

  #
  # making sure signed in users are redirected to their
  # **product** dashboard
  # - see Users::SessionsController for _stored_location_for_
  #
  # def after_sign_in_path_for(resource)
  #   sign_in_url = new_user_session_url
  #   if request.referer == sign_in_url
  #     super
  #   else
  #     stored_location_for(resource) || request.referer || resource.dashboard || root_path
  #   end
  # end

  private

  # update search field on controller for custom search
  # def search lot, query
  #   # raise "You need to implement this on your controller!"
  #   resource_class.search(lot,query)
  # end

  # def set_resource
  #   raise "You need to implement this on your controller!"
  # end

  # update fulltext field on controller for custom fulltext def
  def set_fulltext
    #   raise "You need to implement this on your controller!"
    # return if @resource.nil? || !@resource.valid?
    # @resource.set_fulltext if @resource.respond_to? :set_fulltext
  end

  def find_layout
    'application'
    # unless user_signed_in?
    #   return Dashboard.find(params[:lid]).layout if request.path =~ /\?lid/
    #   return 'application'
    # end
    # return false if %w{ new edit create update clonez print_selection export_selection}.include? params[:action].to_s
    # if current_account != current_user.account
    #   @dashboard = (current_account.dashboard) || Dashboard.new( name: "N/A", layout: "application")
    # else
    #   @dashboard = (current_user.profile.dashboard rescue false) || (current_user.account.dashboard rescue false) || Dashboard.new( name: "N/A", layout: "application")
    # end
    # @dashboard.layout
  rescue StandardError
    raise 'find_layout not working!'
    'application'
  end
end
