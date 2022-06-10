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
  #
  # now in concerns/resource_control.rb: before_action :set_resource
  # now in concerns/resource_control.rb: before_action :set_paper_trail_whodunnit
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
    authorize(:edit) ? respond_with(:new) : not_authorized
  end

  #
  # the standard list of existing records
  # GET /controllers
  #
  # index calls [resources](resource_control#ressources) which will return a [Pagy]() paginated
  # set of records and set a @pagy variable used on the index.html.* template
  #
  # a few params are chipping in:
  #
  # params[:q] - search
  # params[:f] - filter
  # params[:s] - sort
  # params[:ids] - narrow the elements to return
  #
  # and along the way it also sets a @sorting_direction variable for the current (field) sorting
  #
  def index
    authorize(:index) ? respond_with(:index) : not_authorized(true)
  end

  #
  # lookup does the same job as index - except it only returns TURBO_STREAM - and does not care about authorization
  # expecting the caller to otherwise be allowed to!
  #
  # TODO! this obviously is a ways into the system and should be guarding
  #
  def lookup
    respond_with :lookup 
  end
  
  #
  # selected usually works in a combination with lookup - allowing the client to POST a set of selected record ids
  # and returning a TURBO_STREAM driven template
  #
  # TODO! this obviously is a ways into the system and should be guarding
  #
  def selected
    respond_with :selected 
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
    unless authorize(:create)
      not_authorized
    else
      if edit_all_posts
        respond_to do |format|
          format.js { head 201 }
        end
      else
        respond_with :create
      end
    end
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
      # render head: 401 and return unless @authorized
      # render action: "show", layout: false, resource: resource
      render action: "show", resource: resource
      # respond_to do |format|
      #   format.json { }
      #   format.html { render action: "show", layout: false, resource: resource }
      # end
    end

    #
    def show_modal
      # render head: 401 and return unless @authorized
      url = resources_url
      render turbo_stream: turbo_stream.replace( "modal_content", partial: "shared/modals/#{params[:action_content]}", locals: { resource: resource, url: url } )  
    end

    def add_resource
      set_new
      render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } )
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
      attribs = resource_params[:dynamic_attributes].delete_if { |k,v| v.blank? or v.empty? or v.nil? or v == [""] }
      resources.each{|r| r.update_attribute :dynamic_attributes, (r.dynamic_attributes.merge(attribs))}
      true
    end

    def edit_resource
      # render head: 401 and return unless @authorized
      render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } )
    end

    #
    # list_resources is basically here to be overwritten
    # by you if necessary - otherwise it will let
    # the /views/application/index.html.erb do it's job
    # along with the @resources (from concerns/resource_control.rb)
    # and the /views/[resources]/_index_columns.html.erb 
    # and /views/[resources]/_[resource].html.erb
    #
    def list_resources
    end

    #
    # will be serviced by application/lookup.turbo_stream.erb and views/[resource]/_lookup.turbo_stream.erb
    # and because concerns/resource_control takes care of actually getting the content
    # no real code is needed in this method
    #
    def lookup_resources
    end

    #
    # will be serviced by application/selected.turbo_stream.erb and views/[resource]/_selected.html.erb
    #
    def selected_resources
    end

    def clone_resource
      # render head: 401 and return unless @authorized
      @resource = resource.clone_from
      render action: "new", resource: @resource
    end

    def create_resource
      # head 401 and return unless @authorized
      @resource = resource_class.new(resource_params) if @resource.nil?
      # unless resource.valid?
      #   render action: "new", resource: resource, status: 422 and return
      # else
      #   resource.save
      #   # render :show, resource: resource, status: :created and return
      # end
      unless resource.valid? 
        render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      else
        begin        
          resource.save
          respond_to do |format|
            format.turbo_stream { head :ok }
            format.html { head :ok }
            format.json { render json: resource }
          end
        rescue => exception
          resource.errors.add(:base, exception)
          render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
        end
      end
    end

    def update_resource
      # render head: 401 and return unless @authorized
      return if params.include? "edit_all"
      # unless resource.update resource_params
      #   render action: "edit", resource: resource, status: 422 and return
      # else
      #   render action: "show", resource: resource, layout: false, status: :created and return
      # end

      begin        
        unless resource.update resource_params
          render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
        else
          respond_to do |format|
            format.turbo_stream { head :ok }
            format.html { head :ok }
            format.json { render json: resource }
          end
        end
      rescue => exception
        resource.errors.add(:base, exception)
        render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      end
    
    end

    def delete_resource
      # render head: 401 and return unless @authorized
      #
      # TODO: this is not the correct way to respond - with deletes being done by modals!
      #
      unless delete_it
        render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      else
        render turbo_stream: turbo_stream.remove( resource ), status: 303
      end
      #   # hands me this: undefined method `start_with?' for Dashboard:Class
      #   # notice = t('deleted_correctly', resource: t(@resource_class))
      #   respond_to do |format|
      #     format.html { redirect_to resources_url, notice: notice }
      #     format.js { head :no_content}
      #     format.json { head :no_content}
      #   end
      # else
      #   notice = t('was not deleted', resource: t(@resource_class))
      #   respond_to do |format|
      #     format.html { redirect_to resources_url, notice: notice }
      #     format.js { head :unprocessable_entity}
      #     format.json { head :unprocessable_entity}
      #   end
      # end
    end

    def delete_it
      return resource.update(deleted_at: DateTime.now) if params[:purge].blank? && resource.respond_to?(:deleted_at)
      resource.destroy
    end


end



# Another take on a generic way to handle most controller actions:
# https://medium.com/@adrian_teh/refactoring-ruby-on-rails-controllers-using-blocks-bf78b1b292ca
#
# # app/controllers/posts_controller.rb
# class PostsController < ApplicationController
#   def create
#     @post = Post.new(post_params)
#     CreatePost.call(@post) do |success, failure|
#       success.call { redirect_to posts_path, notice: 'Successfully created post.' }
#       failure.call { render :new }
#     end
#   end
# end

# # app/services/create_post.rb
# class CreatePost
#   attr_reader :post

#   def self.call(post, &block)
#     new(post).call(&block)
#   end

#   def initialize(post)
#     @post = post
#   end
#   private_class_method :new

#   def call(&block)
#     if post.save
#       send_email
#       track_activity
#       yield(Trigger, NoTrigger)
#     else
#       yield(NoTrigger, Trigger)
#     end
#   end

#   def send_email
#     # Send email to all followers
#   end

#   def track_activity
#     # Track in activity feed
#   end
# end

# # app/services/trigger.rb
# class Trigger
#   def self.call
#     yield
#   end
# end

# # app/services/no_trigger.rb
# class NoTrigger
#   def self.call
#     # Do nothing
#   end
# end




# from former versions of abstracted_resources_controller:
#
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # before_action :set_fab_button_options
  # before_action :set_variant_template
  # after_action :verify_authorized


# INDEX
  #   respond_with resources do |format|
  #     # format.xlsx {
  #     #   # response.headers['Content-Disposition'] = 'attachment; filename="current_tyre_stock.xlsx"'
  #     #   render xlsx: 'stock_items/index', template: 'current_tyre_stock', filename: "current_tyre_stock.xlsx", disposition: 'inline', xlsx_created_at: Time.now, xlsx_author: "http://wheelstore.space"
  #     # }
  #   end


    # your can override this on your controller
    # def render_on_create format
    #   resource.save && update_parenthood
    #   respond_with resource
    #   # if params.include? "edit_all"
    #   #   if update_all_resources
    #   #     notice = t('all selected posts were updated correctly')
    #   #   else
    #   #     notice = t('all selected posts were not updated correctly')
    #   #   end
    #   # else
    #   #   if resource.save && update_parenthood
    #   #     flash[:notice] = t('.success.created', resource: resource_class.to_s )
    #   #     format.html { render :show, status: :created, notice: t('.success.created', resource: resource_class.to_s ) }
    #   #     format.json { render :show, status: :created, location: resource }
    #   #   else
    #   #     flash[:error] = t('.error.created', resource: resource_class.to_s )
    #   #     format.html { render :new, status: :unprocessable_entity  }
    #   #     format.json { render json: resource.errors, status: :unprocessable_entity }
    #   #   end
    #   # end
    # end

    # your can override this on your controller
    # def render_on_update format
    #   resource.update(resource_params) && update_parenthood
    #   respond_with parent, resource
    #   # if resource.update(resource_params) && update_parenthood
    #   #   flash[:notice] = t('.success.updated', resource: resource_class.to_s )
    #   #   format.html { render :show, status: :ok, notice: t('.success.updated', resource: resource_class.to_s ) }
    #   #   format.json { render :show, status: :ok, location: resource }
    #   # else
    #   #   flash[:notice] = t('.error.updated', resource: resource_class.to_s )
    #   #   format.html { render :edit, status: :unprocessable_entity }
    #   #   format.json { render json: resource.errors, status: :unprocessable_entity }
    #   # end
    # end


#
# load the lib/abstracted_responder.rb
# require "abstracted_responder"

  # self.responder = ::AbstractedResponder



  # def create
  #   authorize resource
  #   ok= resource.save && update_parenthood
  #   respond_with(resource,location: redirect_after_create) do |format|
  #     flash[:notice] = t('.success.created', resource: resource_class.to_s ) if ok
  #   end
  # end

  # def update
  #   authorize resource
  #   ok = resource.update_attributes(resource_params) && update_parenthood
  #   respond_with(resource, location: redirect_after_update) do |format|
  #     flash[:notice] = t('.success.created', resource: resource_class.to_s ) if ok
  #   end
  # end
  # def create
  #   authorize resource
  #   flash[:notice] = t('.success.created',
  #     resource: resource_class.to_s ) if resource.save && update_parenthood
  #   respond_with(resource, location: redirect_after_create ) #do |format|
  #   #   if result_ok
  #   #     flash[:notice] = t('.success.created', resource: resource_class.to_s )
  #   #   else
  #   #     format.html { render action: :new, status: :unprocessable_entity }
  #   #     format.js { render action: :new, status: :unprocessable_entity }
  #   #   end
  #   # end
  # rescue Exception => e
  #   scoop_from_error e
  # end

  # def update
  #   authorize resource
  #   flash[:notice] = t('.success.updated',
  #     resource: resource_class.to_s ) if resource.update_attributes(resource_params) && update_parenthood
  #   respond_with(resource, location: redirect_after_update) # do |format|
  #   #   if result_ok
  #   #     flash[:notice] = t('.success.updated', resource: resource_class.to_s )
  #   #   else
  #   #     format.html { render action: :edit, status: :unprocessable_entity }
  #   #     format.js { render action: :edit, status: :unprocessable_entity }
  #   #   end
  #   # end
  # rescue Exception => e
  #   scoop_from_error e
  # end



  # def destroy
  #   authorize resource
  #   result = true if delete_resource && update_parenthood
  #   result ? (flash.now[:notice] = t('.success', resource: resource_class.to_s)) : (flash.now[:error] = t('.deleted.error',resource: resource_class.to_s) + " " + resource.errors.messages.values.join( " / "))
  #   if result==true
  #     render layout:false, status: 200, locals: { result: true }
  #   else
  #     render layout:false, status: 301, locals: { result: true, errors: resource.errors.messages.values.join( " / ") }
  #   end
  # rescue Exception => e
  #   scoop_from_error e
  # end

      # # you can override this on your controller
    # def redirect_after_create
    #   resources_url {}
    # end

    # # you can override this on your controller
    # def redirect_after_update
    #   resources_url {}
    # end

    # def caught_an_error_already?
    #   result = @caught_an_error_already
    #   @caught_an_error_already ||= true
    #   result
    # end

    # def error_counter
    #   @error_counter ||= 0
    #   @error_counter = @error_counter + 1
    # end


    #
    # use views/../$action.html+mobile.erb if request originates from an iPad
    #
    # def set_variant_template
    #   request.variant = :mobile if request.user_agent =~ /iPad/
    # end


    #
    # build options for fixed action button - implement on each controller to customize
    # raise an exception
    # def set_fab_button_options
    #   opt = { items: {}}
    #   case params[:action]
    #   when 'nothing'; opt = opt
    #   # when 'new';   #opt[:items].merge! print: { ajax: 'get', icon: 'print', class: 'blue lighten-2', url: '/stock_items/print?print_list=true', browser: 'new' }
    #   # when 'edit';  #opt[:items].merge! print: { ajax: 'get', icon: 'print', class: 'blue lighten-2', url: '/stock_items/print?print_list=true', browser: 'new' }
    #   # when 'show';  opt[:items].merge! print: { ajax: 'get', icon: 'print', class: 'blue lighten-2', url: '/stock_items/print', browser: 'new' }
    #   # when 'index'; opt[:items].merge! print: { ajax: 'get', icon: 'print', class: 'blue lighten-2', url: '/stock_items/print?print_list=true', browser: 'new' }
    #   end

    #   # = build_print_link(f.object, list: false, print_options: "print_cmd=print_label", button: 'icon-tag', text: 'Udskriv dæk label')
    #   @fab_button_options = opt
    # end
