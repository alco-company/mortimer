class AssetsController < DelegatedController

  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  #
  def create_resource    
    # result = "#{resource_class.to_s}Service".constantize.new.create resource
    result = AssetService.new.create resource
    resource= result.record
    case result.status
    when :created; head :no_content
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end
  end

  def update_resource
    return if params.include? "edit_all"

    result = AssetService.new.update resource, resource_params
    resource= result.record
    case result.status
    when :updated; head :no_content
    when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
    end
  end

  def delete_it
    return resource.update(deleted_at: DateTime.current) if params[:purge].blank?
    resource.destroy
  end


end
