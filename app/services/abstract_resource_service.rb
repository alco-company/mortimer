class AbstractResourceService
  def create( resource )
    begin
      resource.save
      resource.valid? ? 
        Result.new(status: :created, record: resource) :
        Result.new(status: :not_valid, record: resource)
      
    rescue => exception
      resource.assetable = resource_class.new if resource.assetable.nil?
      Result.new status: :error, record: resource
    
    end
  end

  def update resource, resource_params
    begin        
      resource.update resource_params 
      resource.valid? ? 
        Result.new(status: :updated, record: resource) :
        Result.new(status: :not_valid, record: resource)
    rescue => exception
      resource.errors.add(:base, exception)
      Result.new status: :error, record: resource
    end
  end

  # this should probably be distilled quite a bit!
  def edit_all resources, resource_params
    attribs = resource_params[:dynamic_attributes].delete_if { |k,v| v.blank? or v.empty? or v.nil? or v == [""] }
    resources.each{|r| r.update_attribute :dynamic_attributes, (r.dynamic_attributes.merge(attribs))}
  end

  class Result 
    attr_reader :record, :status
    def initialize(status:, record:)
      @status = status
      @record = record
    end
  end
end

  
  
      # CREATE
      # head 401 and return unless @authorized
      # @resource = resource_class.new(resource_params) if @resource.nil?
      # unless resource.valid?
      #   render action: "new", resource: resource, status: 422 and return
      # else
      #   resource.save
      #   # render :show, resource: resource, status: :created and return
      # end
      # unless resource.valid? 
      #   render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      # else
      #   begin        
      #     resource.save
      #     respond_to do |format|
      #       format.turbo_stream { head :ok }
      #       format.html { head :ok }
      #       format.json { render json: resource }
      #     end
      #   rescue => exception
      #     resource.errors.add(:base, exception)
      #     render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      #   end
      # end

      # render head: 401 and return unless @authorized
      # return if params.include? "edit_all"
      # unless resource.update resource_params
      #   render action: "edit", resource: resource, status: 422 and return
      # else
      #   render action: "show", resource: resource, layout: false, status: :created and return
      # end

      # UPDATE
      # begin        
      #   say resource.to_json
      #   say Current.account.to_json
      #   say Current.user.to_json
      #   say resource_params.to_json
      #   unless resource.update resource_params
      #     render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      #   else
      #     respond_to do |format|
      #       format.turbo_stream { head :ok }
      #       format.html { head :ok }
      #       format.json { render json: resource }
      #     end
      #   end
      # rescue => exception
      #   resource.errors.add(:base, exception)
      #   render turbo_stream: turbo_stream.replace( resource_form, partial: 'form', locals: { resource: resource } ), status: :unprocessable_entity
      # end
