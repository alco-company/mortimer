module AttachDetachPreferHelper

  #
  # URL Helpers
  #

  #
  # attach and detach resources
  def attach_url parent, resource
    '%s/%s/%s/attach' % [url_for( parent), resource.class.to_s.underscore.pluralize, resource.id]
  end

  def detach_url parent, resource
    '%s/%s/%s/detach' % [url_for( parent), resource.class.to_s.underscore.pluralize, resource.id]
  end

  #
  # activate and deactivate resources
  def activate_url resource
    '%s/activate' % url_for(resource)
  end

  def deactivate_url resource
    '%s/deactivate' % url_for( resource)
  end

  #
  # prefer and defer resources - like printers
  def prefer_url parent, resource
    '%s/%s/%s/prefer' % [url_for( parent), resource.class.to_s.underscore.pluralize, resource.id]
  end

  def defer_url parent, resource
    '%s/%s/%s/defer' % [url_for( parent), resource.class.to_s.underscore.pluralize, resource.id]
  end

  #
  # List Helpers
  def set_attached_class children, child
    return "" unless parent?
    return "" if children.nil?
    return "detached" if children.empty?
    children.include?( child) ? "" : "detached"
  end


  # return a link - either to attach_resource_path or detach_resource_path
  # used to attach or detach a resource to its parent
  def build_attach_link children, child
    attached = children.nil? ? false : children.include?( child)
    lbl = attached ? t(:detach) : t(:attach)
    link_to lbl, build_attach_link_url(child,attached), class: "btn btn-mini", remote: true, id: "%s_%i_attdet" % [child.class.to_s, child.id]
  end

  # return the url for the attach_detach_link only
  def build_attach_link_url child, attached
    path = request.path.match( /detach|attach/) ? request.path.split("/")[0..3].join("/") : request.path
    r_url = path + "/%i" % child.id
    attached ? r_url + "/detach" : r_url + "/attach"
  end
  

  # return a link - either to prefer_resource_path or defer_resource_path
  # used to prefer or defer a resource by its parent
  def build_prefer_link children, child
    preferred = (children.include?( child) && child.preferred?( parent))
    return oxt(:preferred) if preferred
    link_to oxt(:prefer), build_prefer_link_url(child,preferred), class: "btn btn-mini", remote: true, id: "%s_%i_predet" % [child.class.to_s, child.id]
  end

  # return the url for the prefer_defer_link only
  def build_prefer_link_url child, preferred
    path = request.path.match( /defer|prefer/) ? request.path.split("/")[0..3].join("/") : request.path
    r_url = path + "/%i" % child.id
    preferred ? r_url + "/defer" : r_url + "/prefer"
  end

end