class AssetsController < DelegatedController
  #
  # we have to 'redefine' the resource calls to provide the proper 
  # form and model insert,update pattern
  # this is less than optimal :(
  # walther 22/3/2022
  #
  # def new_resource
  #   @resource = Asset.new assetable: Employee.new
  # end

  # def resource
  #   @resource = (_id.nil? ? new_resource : Employee.find(_id).asset )
  # end

  # def resource_class
  #   @resource_class ||= Employee
  # end

  #
  # The create_resource is an override to make sure Event is the 'base' entity
  # being created
  # it will render a 303 to satisfy Turbo when success
  #
  # def create_resource    
  #   # result = "#{resource_class.to_s}Service".constantize.new.create resource
  #   result = AssetService.new.create resource(), resource_class()
  #   resource= result.record
  #   case result.status
  #   when :created; redirect_to resources_url, status: :see_other
  #   else render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
  #   end
  # end

  #
  # it will render 303 to satisfy Turbo
  #
  # def update_resource
  #   return if params.include? "edit_all"

  #   result = AssetService.new.update resource(), resource_params, resource_class()
  #   resource= result.record
  #   case result.status
  #   when :updated; redirect_to resources_url, status: :see_other
  #   when :not_valid; render turbo_stream: turbo_stream.replace( resource_form, partial: 'form' ), status: :unprocessable_entity
  #   end
  # end

  # def delete_it
  #   return resource.update(deleted_at: DateTime.current) if params[:purge].blank?
  #   resource.destroy
  # end


end
