#
# AbstractResourcesController affords all the
# standard CRUD operations relieving specialized
# controllers of the mundane job - being able to 
# lazer focus on what ever is special :)
#
class AbstractResourcesController < ApplicationController
  # TODO: respond_to :html, :xml, :js, :json #, :xlsx


  # 
  # This is essential to all controllers which inherit
  # from the AbstractResourcesController - 
  # but as always you may skip it on any controller by
  # overriding the CRUD method definitions (show,new,index,..)
  # in which case you will have to take care of the
  # authorization yourself!
  #
  include Authorization


  # layout lambda { |controller|
  #   if controller.request.headers["Turbo-frame"] == "modal"
  #     "modal"
  #   else
  #     "application"
  #   end
  # }  

  #
  # error handling
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  
  #
  # call PaperTrail with the current_user 
  before_action :set_paper_trail_whodunnit

  #
  # let us decide how/when
  def user_for_paper_trail
    user_signed_in? ? current_user.id : 'API user'  # or whatever
  end  

  #
  # this include builds the breadcrumbs
  #
  include Breadcrumbs

  #
  # this include will prepare the resource and/or resources
  # be it a new resource, an existing, or a paginated set of resources
  # and further set_user_info and more, through UserInfo
  # allowing _non_users_ like punch_clocks access setting Current.punch_clock
  #
  # in concerns/resource_control.rb: before_action :set_resource
  #
  # if you - for some reason - do not want this to happen
  # you may skip it by overriding the `before_action :set_resource`
  # in which case you will have to take care of the
  # resource control yourself, ie setup a new resource, find /resource/:id, etc!
  #
  include ResourceControl

  #
  # this include will afford setting the parent
  # /parents/:parent_id/controllers/:id/action
  #
  include ParentControl

  #
  # this include will make sure that any ActionCable 
  # is signalled properly
  #
  # include CableControl
  
  #
  # this include will afford printing from the ordinary controller
  #
  #
  # include PrintControl

  #
  # this include will afford quick actions like
  # prefer, defer, attach, detach, activate, deactivate
  #
  # include QuickActions

  #
  # the standard show of a record
  # GET /controllers/:id
  #
  def show
    authorize(:show) ? respond_with(:show) : not_authorized
  end

  #
  # this method affords preparing a modal with a selection of contents
  # by returning a turbo_stream of frames to substitute present content on the page
  # depending upon a params[:action_content] = %w( delete share move archive task flag ... )
  #
  def modal 
    authorize( params[:action_content] ) ? respond_with(:modal) : not_authorized
  end

  #
  # the standard new record
  # GET /controllers/new
  #
  def new
    authorize(:new) ? respond_with(:new) : not_authorized
  end

  #
  # the standard edit of an existing record
  # GET /controllers/:id/edit
  #
  def edit
    authorize(:edit) ? respond_with(:edit) : not_authorized
  end

  #
  # the standard list of existing records
  # GET /controllers
  #
  # index calls [resources](resource_control#ressources) which will return a [Pagy]() paginated
  # set of records and set a @pagy variable used on the index.html.* template (unless provided with
  # an ids params in which case the identified records are returned)
  #
  # a few params are chipping in:
  #
  # params[:q] - search
  # params[:f] - filter
  # params[:s] - sort
  # params[:d] - sorting direction
  # params[:ids] - narrow the elements to return
  #
  # and along the way it also sets a @sorting_direction variable for the current (field) sorting
  #
  def index
    authorize(:index) ? respond_with(:index) : not_authorized(true)
  end

  #
  # lookup does the same job as index - except it only returns TURBO_STREAM - and does not care about authorization
  # expecting the caller to otherwise be allowed to! This clearly is a way into the system and should be guarded!
  # Best bet is guard it with accepting only TURBO_STREAM requests!
  #
  # used by components like combo_component, and more
  #
  # TODO! this obviously is a ways into the system and should be guarded
  #
  def lookup
    request.format.symbol == :turbo_stream ? respond_with(:lookup) : not_authorized(true)
  end
  
  #
  # selected usually works in a combination with lookup - allowing the client to POST a set of selected record ids
  # and returning a TURBO_STREAM driven template
  #
  # TODO! this obviously is a ways into the system and should be guarding - like 
  # with lookup fx guarding it with accepting only TURBO_STREAM requests!
  #
  def selected
    request.format.symbol == :turbo_stream ? respond_with(:selected) : not_authorized
  end

  #
  # the standard create of a new record - with a twist
  # POST /controllers
  # create will sparingly inform about the success - using the status like https://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option
  #
  # the twist being that if params[:edit_all] is true - whatever records have been selected (the params[:q] and possibly params[:f])
  # are updated instead
  #
  def create
    authorize(:create) ? respond_with(:create) : not_authorized
  end

  #
  # the standard update of an existing record
  # PATCH /controllers/:id
  # update will sparingly inform about the success - using the status like https://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option
  #
  def update
    authorize(:update) ? respond_with(:update) : not_authorized
  end

  #
  # the standard delete of an existing record - but with a twist
  # POST /controllers/:id?_method=delete
  #
  # the twist being that if params[:purge] is true - destroy the item otherwise set the deleted_at attribute
  #
  def destroy
    authorize(:destroy) ? respond_with(:destroy) : not_authorized
  end

  #
  # remove an image - if the resource has any
  #
  def remove_image
    unless authorize(:destroy)
      not_authorized
    else
      if (resource.respond_to?( :images ) && !params[:image_id].blank?)
        resource.images.find(params[:image_id]).purge 
      end
      respond_to do |format|
        format.json { head 200 }
      end
    end
  end

  #
  # this method affords cloning/copying an existing record - in one go
  # GET /controllers/:id/clonez
  #
  # it is by itself an ordinary GET of an existing record
  # but then the cloning kicks in! Using the deep_clone gem this
  # method will pull details for an order, attachments for an email, etc
  #
  # TODO the authorize should accommodate for the 'clonez' action 
  # but until then - verify that the user can 'create'
  #
  def clonez
    authorize(:create) ? respond_with(:clone) : not_authorized
  end

  private

    def record_not_found
      flash[:error] = raw_t(:record_not_found)
      redirect_to action: 'index'
      # render( head 404) and return
    end


    #
    # you can over-ride the entire CRUD-train
    # by implementing any of these in your controller !
    #
    def respond_with action
      case action
      when :show;     show_resource
      when :modal;    show_modal
      when :new;      add_resource
      when :edit;     edit_resource
      when :index;    list_resources
      when :lookup;   lookup_resources
      when :selected; selected_resources
      when :clone;    clone_resource
      when :create;   create_resource
      when :update;   update_resource
      when :destroy;  delete_resource
      end
    end

    #
    def show_resource
      render action: "show", resource: resource
      # respond_to do |format|
      #   format.json { }
      #   format.html { render action: "show", layout: false, resource: resource }
      # end
    end

    #
    def show_modal
      url = resources_url
      render turbo_stream: turbo_stream.replace( "modal_content", partial: "shared/modals/#{params[:action_content]}", locals: { resource: resource, url: url } )  
    end

    def add_resource
      set_new
      render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } )
      # 29/5/2019 removed - using ancestry instead!
      # resource.parent_id = params[:parent_id] if resource.respond_to? :parent_id
    end

    #
    # set_new - implement on your controller if some processing is required
    # in order to present a 'new' record
    def set_new      
    end


    #
    # generically we cannot but update the `:dynamic_attributes` attribute
    # but you may override this on any controller
    #
    def edit_all_posts
      return false unless params[:edit_all]=="1"
      AbstractResourceService.new.edit_all resources, resource_params
      true
    end

    def edit_resource
      render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } )
    end

    #
    # list_resources is basically here to be overwritten
    # by you if necessary - otherwise it will let
    # the /views/application/index.html.erb (or index.turbo_stream.erb) do it's job
    # along with the @resources (from concerns/resource_control.rb)
    # and the /views/[resources]/_index_columns.html.erb 
    # and /views/[resources]/_[resource].html.erb
    #
    def list_resources
    end

    #
    # lookup_resources is a generic action that can be used to lookup resources
    # particularly useful for combo_select form inputs, generating GET's like
    #
    # GET "/organizations/lookup?stimulus_controller=resource--combo-component&stimulus_lookup_target=selectOptions&lookup_target=organizations&values=&add=false&q=ki"
    # 
    # called by the /lookup action defined above
    #
    # on the resource being lookup'ed the following method are called: combo_values_for_FIELDNAME - eg combo_values_for_organization_id
    # which should return an array of values id, name for each 'selected' value from the lookup'ed table - eg organizations
    #
    # selecting an item from the lookup will call the /index?ids=[] action defined above - with ids selected
    # and expect to get back a JSON builder from views/{resource|application}/index.json.builder - eg /views/organizations/index.json.jbuilder
    # which will require you to implement a partial for each resource - eg /views/organizations/_organization.json.jbuilder
    #
    # will be serviced by application/lookup.turbo_stream.erb and views/{resource|application}/_lookup.turbo_stream.erb
    # and because concerns/resource_control takes care of actually getting the content
    # no real code is needed in this method
    #
    # this method is the default implementation used by combo_select and can be overwritten by you if necessary
    #
    def lookup_resources 
      @target=params[:target]
      @value=params[:value]
      @element_classes=params[:element_classes]
      @selected_classes=params[:selected_classes]
    end

    #
    # will be serviced by application/selected.turbo_stream.erb and views/[resource]/_selected.html.erb
    #
    # this method only exists to be overwritten by you if necessary
    #
    def selected_resources
    end

    def clone_resource
      # render head: 401 and return unless @authorized
      @resource = resource.clone_from
      render action: "new", resource: @resource
    end

    # The very essense of C in the CRUD - 
    # any controller not required to do special stuff
    # will inherit from this method
    # create_resource will instantiate an AbstractResourceService object
    # and call create on it, returning an instance of Result (defined on AbstractResourceService)
    #
    # if, however, the user is editing a selection of records
    # see edit_all_posts 
    def create_resource
      return create_update_response if edit_all_posts

      # Each resource could have it's own - 
      result = "#{resource_class.to_s}Service".constantize.new.create resource()
      resource= result.record
      case result.status
      when :created; create_update_response
      when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
      end
    end
    
    # The very essense of U in the CRUD - 
    # any controller not required to do special stuff
    # will inherit from this method
    # update_resource will instantiate an AbstractResourceService object
    # and call update on it, returning an instance of Result (defined on AbstractResourceService)
    def update_resource
      # Each resource could have it's own - 
      result = "#{resource_class.to_s}Service".constantize.new.update  resource(), resource_params
      resource= result.record
      case result.status
      when :updated; create_update_response
      when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
      end    
    end

    # if the create/update methods ends well - 
    # tell the UI
    def create_update_response
      respond_to do |format|
        format.turbo_stream { redirect_to resources_url, status: :see_other }
        format.html { head :ok }
        format.js { head 201 }
        format.json { render json: resource }
      end
    end

    def delete_resource
      # TODO: this is not the correct way to respond - with deletes being done by modals!
      #
      result = "#{resource_class.to_s}Service".constantize.new.delete resource(), params
      case result.status
      when :deleted; render turbo_stream: turbo_stream.remove( resource ), status: 303
      when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      end
    end

end
