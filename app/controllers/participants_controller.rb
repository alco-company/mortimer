class ParticipantsController < DelegatedController

  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  #
  def create_resource
    render head: 401 and return unless @authorized
    resource.participantable = resource_class.new if resource.participantable.nil?
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
    begin        
      unless resource.update resource_params
        resource.participantable = resource_class.new if resource.participantable.nil?
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

  # def create_resource
  #   render head: 401 and return unless @authorized
  #   resource = Participant.new(resource_params)
  
  #   unless resource.valid? 
  #     render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
  #   else
  #     resource.save
  #   end
  # end


  # def delete_resource
  #   render head: 401 and return unless @authorized
  #   element = resource.participantable
  #   unless delete_it
  #     render turbo_stream: turbo_stream.replace( "resource_form", partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
  #   else
  #     render turbo_stream: turbo_stream.remove( element ), status: 303
  #   end
  # end

end
