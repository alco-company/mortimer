module ParentsHelper

  #
  # URL Helpers
  #
  # parent

  #
  # parent returns the parent entity
  def parent
    @parent ||= find_parent #parent? ? @parent : raise("parent will return nil - which probably was not anticipated!")
  end

  #
  # parent_class returns the class of the parent
  def parent_class
    Rails.logger.warn "parent_class will return Object - which probably was not anticipated!" if @parent.nil?
    parent? ? @parent.class : nil
  end

  #
  # parent_name returns the name of the resource - that would be the empty string on nil's
  def parent_name
    parent? ? parent_class.to_s.pluralize.underscore : raise("parent_name will return '' - which probably was not anticipated!")
  end

  #
  # parent_url returns the parent url - /employees/1 in the /employees/1/events
  def parent_url
    parent? ? ( "/" + parent_class.to_s.pluralize.underscore + "/%s" % @parent.id) : "no_route_to_parent"
  end

  #
  # parent? will tell if a parent exists
  def parent?
    !(%w{NilClass TrueClass FalseClass}.include? parent.class.to_s)
  end

  def find_parent
    return params[:parent].classify.constantize.find(params[:parent_id]) if (params[:parent] && params[:parent_id])
    return current_user.account unless (current_user.nil? or current_user.is_a_superuser?)

    path = params[:path] || request.path
    paths=path.split("/")
    paths.shift if paths[0]==""
    return nil if paths.size < 3
    paths.pop if %w{new edit show create update delete index attach detach prefer defer activate deactivate print clonez}.include? paths[-1].split(".")[0]
    return nil if (paths.size < 3)
    return paths[0].singularize.classify.constantize.find(paths[1])
  rescue
    nil
  end

  #
  # ancestrals
  # really like a parent just perhaps not that old !?
  def ancestrals
    ancestral_path = request.path.slice 0,(request.path.index(resource_class.to_s.underscore)-1)  #  /accounts/:id/ancestrals/:ancestrals_id
    *,model,id = ancestral_path.split("/")
    model.classify.constantize.find(id)
  rescue
    nil
  end

  def ancestors_for resource 
    return policy_scope(resource_class.all).collect{|a| [a.card_header,a.id]} unless resource.ancestors?
    resource.ancestors.collect{|a| [a.card_header,a.id]}
  end


  def ancestors_for resource 
    return policy_scope(resource_class.all).collect{|a| [a.card_header,a.id]} unless resource.ancestors?
    resource.ancestors.collect{|a| [a.card_header,a.id]}
  end
  
end