class AssetService < AbstractResourceService
  def create( resource )
    resource.account ||= Current.account
    resource.calendar ||= Calendar.new(name: resource.name)
    resource.name ||= resource_class.to_s + " not defined"
    resource.state ||= ""
    resource.position ||= 1
    resource.ancestry ||= nil # ancestry cannot be an empty string! 

    result = super(resource)
    if result.status != :created 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end

  def update( resource, resource_params )
    result = super(resource,resource_params)
    if result.status != :updated 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end
end