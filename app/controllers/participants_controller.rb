class ParticipantsController < DelegatedController

  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  #
  def create_resource
    return create_update_response if edit_all_posts

    # Each resource could have it's own - 
    # result = "#{resource_class.to_s}Service".constantize.new.create resource
    result = "#{resource_class.to_s}Service".constantize.new.create resource()
    resource= result.record
    case result.status
    when :created; create_update_response
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end
  end

  def update_resource
    # Each resource could have it's own - 
    # result = "#{resource_class.to_s}Service".constantize.new.create resource
    result = "#{resource_class.to_s}Service".constantize.new.update  resource(), resource_params
    resource= result.record
    case result.status
    when :updated; create_update_response
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end    
  end

  def delete_it
    return resource.update(deleted_at: DateTime.current) if params[:purge].blank?
    resource.destroy
  end

end
