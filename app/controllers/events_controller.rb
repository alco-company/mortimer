#
# The Event is one of the 4 core entities - Event, Participant, Message, and Asset
# and it override a few methods from the AbstractedResourcesController
#
class EventsController < DelegatedController

  def new_resource 
    r=Event.new eventable: resource_class.new
    #
    # endpoints like /employees/15/tasks will 'auto-assign' the employee 
    # to tasks
    if parent?
      r.assignments.new( assignable: (parent_class.find(parent.id) rescue nil))
    end
    r
  end

  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  #
  def create_resource
    render head: 401 and return unless @authorized
    @resource= Event.new(resource_params)
    unless resource.valid? 
      render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form' ), status: :unprocessable_entity
    else
      begin        
        resource.save
        head :no_content
      rescue => exception
        resource.errors.add(:base, exception)
        render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form' ), status: :unprocessable_entity
      end
    end
  end

  def update_resource
    render head: 401 and return unless @authorized
    return if params.include? "edit_all"
    @resource = resource_class.find(_id).event
    begin        
      unless resource.update resource_params
        render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form' ), status: :unprocessable_entity
      end
    rescue => exception
      resource.errors.add(:base, exception)
      render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form' ), status: :unprocessable_entity
    end
  
  end

  def delete_it
    return resource.update(deleted_at: DateTime.current) if params[:purge].blank?
    resource.destroy
  end


end
