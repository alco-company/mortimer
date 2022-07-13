class EventService < AbstractResourceService
  def create( resource, resource_class )
    result = super(resource)
    if result.status != :created 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end

  def update( resource, resource_params, resource_class )
    result = super(resource,resource_params)
    if result.status != :updated 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end


  
end