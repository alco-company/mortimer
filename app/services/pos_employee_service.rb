class PosEmployeeService < AbstractResourceService

  def punch_in
    
  end

  def create( resource, resource_class )
    # resource.calendar = CalendarService.new.create(resource, resource_class) if resource.calendar.blank?
    resource.calendar = Calendar.new(name: resource.name) if resource.calendar_id.blank?
    result = super(resource)
    if result.status != :created 
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end

  def update( resource, resource_params, resource_class )
    result = super(resource,resource_params)
    if result.status != :updated
      resource.participantable = resource_class.new if resource.participantable.nil?
    end
    result
  end

end