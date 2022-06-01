class AssetsController < DelegatedController

  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  #
  def create_resource
    return not_authorized unless authorize(:create)
    unless resource.valid? 
      resource.assetable = resource_class.new if resource.assetable.nil?
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
    return not_authorized unless authorize(:create)
    return if params.include? "edit_all"
    # @resource = resource_class.find(_id).asset
    begin        
      unless resource.update resource_params
        resource.assetable = resource_class.new if resource.assetable.nil?
        render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form' ), status: :unprocessable_entity
      end
    rescue => exception
      resource.errors.add(:base, exception)
      render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form' ), status: :unprocessable_entity
    end
  
  end

  def delete_it
    return resource.update(deleted_at: DateTime.now) if params[:purge].blank?
    resource.destroy
  end


end
