module ResourcesHelper


  #
  # URL Helpers
  #

  #
  # resource

  #
  # did we manage to set a resource at all?
  def resource?
    !(%w{NilClass TrueClass FalseClass}.include? @resource.class.to_s)
  end

  #
  # resource returns the current entity
  def resource
    return nil unless resource? 
    return @resource.delegated_from if (@resource.respond_to? :delegated_from) && ( %w( new edit create update destroy ).include? params[:action] )
    @resource
  end

  #
  # new_resource? returns true/false whether it is a new resource or not
  def new_resource?
    resource.new_record?
  end

  #
  # returns the name of the current resource - like user for User resources
  #
  def resource_name
    resource_class.to_s.underscore
  end

  #
  # resource_name as symbol
  #
  def resource_symbol
    resource_name.to_sym
  end

  #
  # returns the resource_class pluralized - eg: stock_item => 'stock_items'
  #
  def resources_name
    resource? ? resource.resources_name : resource_class.to_s.underscore.pluralize
  end

  #
  # resource_class is the class which the resource represent
  def resource_class
    return @resource_class if resource?
    @resource_class = params[:controller].gsub('/pos','').split("/")[0].singularize.classify.constantize 
  rescue
    raise("resource_class will return Object - which probably was not anticipated!")
  end

  #
  # resource_url returns the current entity's url
  def resource_url options={}
    return url_for(options) unless options=={}
    return url_for(resource)
    # case resource_class.to_s
    # when 'Asset', 'Product'; url_for resource.assetable
    # when 'Participant'; url_for resource.participantable
    # else
    #   url_for(resource)
    # end
    # r=request.path
    # id=resource.id || params[:id]
    # options = case params[:action]
    #   when 'create','update','delete','destroy'; ""
    #   else resource_options(options)
    # end
    # return "%s%s" % [r,options] if r.match "\/#{resource.class.to_s.tableize}\/#{id}(|\/#{params[:action]})$"
    # "%s%s" % [ r.split("/#{params[:action]}")[0], options]

    # opt = {}
    # opt[:id] = options.id if options.class.ancestors.include? ActiveRecord::Base # edit_resource_url(@post)
    # opt.merge!(options) if options.class==Hash
    # opt[:action] ||= 'show'
    # opt[:id] ||= resource.id
    # opt[:controller] ||= resource_class.table_name
    # url_for opt
  end

  def resource_options options={}
    options.merge! params.except( "id", "controller", "action", "utf8", "_method", "authenticity_token" )
    options.empty? ? "" : "?" + options.collect{ |k,v| "#{k}=#{v}" }.join("&")
  end

  #
  # new_resource_url returns a new entity
  def new_resource_url(options={})
    opt = {}
    opt.merge!(options) if options.class==Hash
    opt[:controller] ||= resource_class.table_name
    opt[:action] = :new
    url_for opt
  end

  #
  # edit_resource_url returns the current entity's url for editing
  def edit_resource_url(options={})
    "%s/edit" % url_for(options)
    # opt = {}
    # if options.class.ancestors.include? ActiveRecord::Base # edit_resource_url(@post)
    #   return '' if options.id.nil? # raise "'id' value nil - cannot build edit_resource_url"
    #   opt[:id] = options.id
    # else
    #   opt.merge!(options) if options.class==Hash
    # end
    # opt[:action] = :edit
    # resource_url opt
    # opt[:id] ||= @resource.id
    # opt[:controller] ||= @resource_class.table_name
    # url_for opt
  end

  #
  # resources

  #
  # returns the current collection of entities
  def resources
    @resources
  end


  #
  # this method is used when building forms using Turbo(frames)
  # you can override this to have a custom form - eg when forms clash!
  #
  def resource_form rs=nil
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


  def resources_url resources=@resources, options={}
    if resources == @resources 
      @resources_url ||= build_resources_url resources, options 
      return @resources_url 
    end
    build_resources_url resources, options
  end

  #
  # resources_url returns the current collection of entities' url
  def build_resources_url resources=@resources, options={}
    #
    # lnk = parent? ? (parent_url + "/#{resource_name}") : "/#{resource_name}"
    # lnk += options.empty? ? "" : "?" + options.collect{ |k,v| "#{k}=#{v}" }.join("&")
    if parent?
      
      # return [parent_url,url_for(params[:controller]),params[:id]].join("/") if params[:action]=="edit"
      # return [parent_url,url_for(params[:controller])].join("/")
    end
    r = request.path 
    u = r.split("/")
    u.pop if %w{edit new}.include? u[-1]
    # Rails.logger.info ">>>>> #{r} -> #{u.join("/")}"

    return u.join("/")
    # return url_for [params[:controller],params[:id]].join("/") if params[:action]=="edit"
    # url_for params[:controller]
    # action = case params[:action]
    # when "edit"; :show
    # else :index
    # end
    # options = resources if resources.class == Hash
    # opt = {}
    # opt.merge!(options) if options.class==Hash
    # opt[:controller] ||= resource_class.table_name
    # opt[:action] ||= action
    # url_for opt
  rescue
    #
    # return the root_url if no route was found!
    root_url
  end
  

  #
  #
  def show_resource_active item, linkable=true
    unless linkable
      if item.active
        content_tag :i, 'done', class: "material-icons small"
      else
        content_tag :i, 'pause', class: "material-icons small"
      end
    else
      if item.active
        link_to deactivate_url(item), class: 'activated green-text', title: t("deactivate_#{item.resource_name}") do
          content_tag :i, 'done', class: 'material-icons'
        end
      else
        link_to activate_url(item), class: 'deactivated red-text', title: t("activate_#{item.resource_name}") do
          content_tag :i, 'pause', class: 'material-icons'
        end
      end
    end
  end

  #
  # return a link to delete a row
  def show_resource_delete_icon item, url, lbl='name'
    link_to item, class: 'delete_link', data: { delete_title: t("delete_title"), delete_prompt: t("delete_prompt", item: t("delete_modal.#{item.class.to_s.underscore}")), delete_confirm: t("delete_confirm"), balloon: t("balloons.delete" ), balloon_pos: "left", url: url, name: "#{item.send lbl }", id: "#{item.id}", remove: "#tr-#{item.class.to_s}-#{item.id}" } do
      content_tag :i, 'delete', class: 'material-icons small'
    end
    # = link_to account, class: 'delete_link', data: { url: '/admin/accounts', name: "#{account.name}", id: "#{account.id}", remove: "#tr-#{account.id}" } do
    #   %i.material-icons.small{ title: "#{t('.delete')}"} delete

  end


  # return an array url, list, options
  # options{ url: '', button: '', classes: '', text: ''}
  def build_resource_url resource, options={}
    print_options = options.delete(:print) || {}
    args = add_print_params params.merge( print: print_options)
    data_attribs = options.delete(:data) || {}
    list = print_options[:format]=='list' || false
    url = "%s/print?%s" % [ options.delete(:url) || ( !list ? url_for( resource) : url_for(resource_class.to_s.underscore.pluralize) ), args ]
    [ url, list, options.merge( data: data_attribs) ]
  end

end