require 'active_support/concern'

# require "parent_control"
# load the concerns/parent_control.rb

module ResourceControl
  extend ActiveSupport::Concern

  #
  # set basic information about the user
  include UserInfo

  included do

    before_action :set_user_info
    before_action :set_resource_class
    before_action :set_resource, except: [ :index, :lookup, :selected ]
    before_action :set_resources, only: [ :index, :print, :lookup, :selected ]

  end

  def resource_params
    raise 'You need to "def resource_params" on the %sController! (see: http://blog.trackets.com/2013/08/17/strong-parameters-by-example.html)' % params[:controller].capitalize
  end

  def set_resource_class
    @resource_class ||= params[:controller].split("/").last.singularize.classify.constantize
  end
  
  def set_resource
    parent
    resource
  end
  
  def set_resources
    resources
  end
  
  def resource?
    !(%w{NilClass TrueClass FalseClass}.include? @resource.class.to_s)
  end
  
  #
  # resource is divided into 2 main categories
  #
  # 4 core resources from which a majority of resources are delegated_from
  # other resources like dashboards, roles, profiles, and other supporting resources
  #
  # the 4 core resources are Event, Message, Participant, Asset
  # in which case calling for a resource will return the core resource
  # provided the action is one of 'new' 'edit', 'create', 'update', or 'destroy'
  #
  def resource
    @resource ||= (_id.nil? ? new_resource : resource_class.find(_id) )
    return @resource.delegated_from if (@resource.respond_to? :delegated_from) && ( %w( new edit create update destroy ).include? params[:action] )
    @resource
  end

  def resource= var 
    @resource=var 
  end

  # def resource=val
  #   @resource=val
  # end

  def new_resource?
    resource.new_record?
  end

  #
  # calling upon the resource with no _id ends up here
  # being serviced with a new_resource
  #
  # when the resource_class.new.respond_to? :delegated_from
  # we will return a blank core resource - unless params.include? a core resource reference
  # like eg. "asset" => {} - in which case we will return a new resource using the params
  # 
  # when the resource_class.new doesn't respond_to? :delegated_from
  # this resource is not delegated_from a core resource and as such
  # we can return either a blank resource_class.new when no params
  # or a resource_class.new(params) depending upon the contents of the params
  #
  def new_resource
    return nil if resource_class.nil?
    r = resource_class.new.respond_to?( :delegated_from ) ? resource_class.delegated_from  : resource_class
    return r.new_rec(resource_class) unless (params.include? r.to_s.underscore)
    
    p = resource_params
    p=p.compact.first if p.class==Array
    rr= r.ancestors.include?( ActiveRecord::Base) ? r.new(p) : r.new
    if parent? && rr.respond_to?(:assignments)
      rr.assignments.new( assignable: (parent_class.find(parent.id) rescue nil))
    end
    rr

  rescue => err
    raise "new_resource failed due to #{err}"
  end

  def _id
    return nil if !params[:id] || params[:id]=="0"
    params[:id] || params["#{resource_class.to_s.underscore}_id".to_sym]
  end

  def resource_name options={}
    @resource_name ||= resource_class.to_s.underscore
  end

  def resource_symbol
    @resource_symbol ||= resource_name.to_sym
  end

  def resources_name options={}
    resource_class.table_name
    # resource_class.to_s.underscore.pluralize
  end

  def resource_class
    return @resource_class if resource?
    @resource_class ||= params[:controller].gsub('/pos','').split("/")[0].singularize.classify.constantize
  end

  def resource_class= val
    @resource_class = val
  end

  #
  # this method is used when building forms using Turbo(frames)
  # you can override this to have a custom form - eg when forms clash!
  #
  def resource_form rs=nil
    #
    # this is a terrible hack :( 
    # due to the fact that the <form id="#{resource_form}"> does not change on
    # show pages like /stocks/1 with tabs angling for new resources like /stocks/1/stock_locations/new
    #
    # TODO: make show pages with tabs change the 'resource_form' id to the correct one
    #
    return "stock_form" if request.url =~ /stocks.*stock_locations/
    # rs ||= resource
    return ("form_%s" % (Current.user.id rescue '0')) # if rs.nil?
    # "%s_%s_form" % [rs.class.to_s.underscore, (rs.id rescue 'new')]
  end

  #
  # this method is used when building lists of records using Turbo(streams)
  # you can override this to have a custom list - eg when lists clash!
  #
  def resources_target
    resource_class.to_s.pluralize.underscore 
  end

  #
  #
  # return the resources collection - preferably from the cache
  # it will call find_resources which you may specialize on the controller
  #
  def resources options={}
    @resources ||= find_resources options
  end

  #
  # return the resource in an edit action
  #
  def edit_resource_url options={}
    url_for(resource, options)+"/edit"
  end

  #
  # returns the url for the resource - like
  # /users/1
  # /accounts/2/users/1
  #
  def resource_url entity={}
    url_for resource
    # parr = request.path.split("/")
    # p = case params[:action]
    #   when 'new','edit','destroy'; parr[0..-2].join("/")
    #   else parr.join("/")
    #   end
    # url_for(p)
    # r=request.path
    # id=params[:id]
    # options = case params[:action]
    #   when 'create','update','delete','destroy'; ""
    #   else resource_options(options)
    # end
    # return "%s%s" % [r,options] if r.match "#{resource_class.to_s.tableize}\/#{id}$"
    # "%s%s" % [ r.split("/#{params[:action]}")[0], options]
  end


  #
  # returns the url for the resources - /employees or /employees/1/events or /employees/54/tasks/modal?ids=17&action_content=delete
  def resources_url options={}
    r=request.path
    options = case params[:action]
      when 'create','update','delete','destroy'; ""
      when 'modal'; r= r.split("/")[0..-2].join("/"); resource_options(options)
      else resource_options(options)
    end
    return "%s%s" % [r,options] if r.match "#{resource_class.to_s.tableize}$"
    u = "%s%s%s" % [ r.split( resource_class.to_s.tableize)[0],resource_class.to_s.tableize, options]
    # Rails.logger.info ">>>>> #{r} -> #{u}"
    u
  end

  def resource_options options={}
    prm = params.permit!
    options.merge! prm.except( "id", "controller", "action", "utf8", "_method", "authenticity_token" )
    options.empty? ? "" : "?" + options.collect{ |k,v| "#{k}=#{v}" }.join("&")
  end

  #
  # find the resources collection
  def find_resources options
    if ids.any?
      Rails.logger.info "ids: #{ids}"
      policy_scope(resource_class).where(id: ids ) 
    else
      # search
      r = _search options

      # filter
      r = _filter r, options

      # sort
      r = _sort r, options

      # paginate
      r = _paginate r

      # (params[:format].nil? or params[:format]=='html') ? r.page(params[:page]).per(params[:perpage]) : r
    end
  end

  def ids
    @ids ||= (
      # return [] if 0==(request.path =~  /^\/accounts$/) #and !current_user.is_a_superuser?
      # return [] unless resource_class.ancestors.include? ActiveRecord::Base
      if params[:ids].blank? or params[:ids] == 'undefined'
        params[:ids] = []
      else
        if params[:ids].is_a? String 
          params[:ids] = [ params[:ids] ]
          params[:ids] << params[:id] unless params[:id].nil?
        end
      end
      #
      # [",1,2",nil,"","3"] => ["1", "2", "3"]
      params[:ids].map{|m| m.split(",") unless m.blank? }.compact.flatten.filter{|f| !f.blank?}
    )

  end

  #
  # search - it at all
  #
  def _search options
    if params[:q].blank?
      parent? ? find_parent_resources(options) : find_all_resources(options)
    else
      find_resources_queried options
    end
  end

  #
  # filter - it at all
  #
  def _filter r, options
    return r if params[:f].blank?
    return resource_class.filter r, params[:f], options if resource_class.respond_to? :filter
    r
  end

  #
  # sort - it at all
  #
  # allow listings to be sorted by some of the columns - by tapping the column lead text
  # the current selection of records will be sorted by that field in ASC order and tapping
  # the same column once more will reverse the order to DESC
  #
  # use this helper in your listing column headers:
  #
  # <%= sort_link_to t('.long_lat'), :long_lat, data: { turbo_action: "advance"} %>
  #
  # %th{ role:"sort", data{ field: "*barcode", direction: "DESC"} }
  # $('th[role="sort"]')
  def _sort r, options
    r.reorder sorting_direction
  end

  def sorting_direction
    s = params[:s] ? params[:s].to_sym : :id
    direction = %w{asc desc}.include?( params[:d]) ? params[:d].to_sym : :asc
    { s => direction }
  end

  #
  # paginate - it at all
  #
  def _paginate r
    #
    # pagination is not for the printer - it's only for screens
    #
    return r if params[:action]=='print'
    return r if params[:all]=='true'
    return r if params[:edit_all]=='1'

    #
    # we wouldn't like a error here due to a 'nilled' resources-set
    unless r.nil?
      @pagy, r = pagy(r, items: params.fetch(:items,10) )
    end
    r
  end

  #
  # find resources on parent
  #
  def find_parent_resources options 
    say resources_name
    policy_scope(parent.send(resources_name))
  end

  #
  # find queried resources collection - implement on each controller to customize
  # raise an exception
  def find_all_resources options
    policy_scope(resource_class.default_scope)
  end

  #
  # find queried resources collection - implement on each controller to customize
  # raise an exception
  def find_resources_queried options
    return search(policy_scope(resource_class.default_scope),params[:q]) unless resource_class.respond_to?( "tags_included?")
    case params[:f]
    when nil
      if parent?
        policy_scope(resource_class.default_scope).tags_included?( params[:q].split(" ") ).where( options )
      else
        policy_scope(resource_class.default_scope).tags_included?( params[:q].split(" ") )
      end
    else
      policy_scope(resource_class.default_scope)
    end
  end

  #
  # TODO: implement alternative to Pundit - or implement Pundit!
  # no pundit!
  #
  # policy_scope
  #
  def policy_scope arg
    return arg if resource_class == Account
    return arg.where("events.account_id = ?", current_account) if resource_class.new.respond_to? "event"
    return arg.where("assets.account_id = ?", current_account) if resource_class.new.respond_to? "asset"
    return arg.where("participants.account_id = ?", current_account) if resource_class.new.respond_to? "participant"
    return arg.where("account_id = ?", current_account) if resource_class.new.respond_to? "account"
    return arg if current_user #and current_user.is_a_superuser?
    # arg.where account: Account.current.id
  end

  #
  # implement on every controller where search makes sense
  # get's called from resource_control.rb 
  #
  # def find_resources_queried options
  #   raise "you need to implement def find_resources_queried end on this controller"
  #   # get <selectize> lookups
  #   # if request.format.symbol==:json
  #   #   Dashboard.search Dashboard.all, params[:q]
  #   # else
  #   #   Dashboard.search Dashboard.all, params[:q]
  #   # end
  # end


  class_methods do
  end

end
