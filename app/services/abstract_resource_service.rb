#
# Most resources are easily inserted
# and will return a Result hash with 
# a status and a record persisting the
# ActiveRecord
#
class AbstractResourceService
  def create( resource )
    begin
      # puts "called-------------\n"
      # puts resource.errors.to_json unless resource.valid?
      # puts "er resource klar til at blive gemt? #{resource.valid?}"
      resource.save
      # puts "saved"
      resource.valid? ? 
        Result.new(status: :created, record: resource) :
        Result.new(status: :not_valid, record: resource)
      
    rescue Exception => exception
      # puts "SQL error in #{ resource.save.explain }"
      # puts "SQL error #{ exception }"
      ActiveRecord::Base.connection.execute 'ROLLBACK' 
      Result.new status: :error, record: resource      
    end
  end
  
  def update( resource, resource_params )
    begin        
      resource.update resource_params 
      resource.valid? ? 
      Result.new(status: :updated, record: resource) :
      Result.new(status: :not_valid, record: resource)
    rescue => exception
      ActiveRecord::Base.connection.execute 'ROLLBACK' 
      resource.errors.add(:base, exception)
      Result.new status: :error, record: resource
    end
  end
  
  #
  # deleting a resource will usually mean softdeleting it
  # by ways of updating the deleted_at attribute with the
  # current timestamp
  #
  def delete( resource )
    begin        
      resource.update_attribute :deleted_at, DateTime.current
      Result.new(status: :deleted, record: resource)
    rescue => exception
      ActiveRecord::Base.connection.execute 'ROLLBACK' 
      resource.errors.add(:base, exception)
      Result.new status: :error, record: resource
    end
  end

  # this should probably be distilled quite a bit!
  #
  # records having dynamic_attributes may be
  # batch updated with a set of attributes - which is
  # an easy way of changing fx profit margin on all
  # products of a particular category, expire a selected
  # set of stock_items, etc
  #
  def edit_all resources, resource_params
    attribs = resource_params[:dynamic_attributes].delete_if { |k,v| v.blank? or v.empty? or v.nil? or v == [""] }
    resources.each{|r| r.update_attribute :dynamic_attributes, (r.dynamic_attributes.merge(attribs))}
  end

  #
  # Result is the hash returned by a service
  # after creating, updating, or deleting it
  class Result 
    attr_reader :record, :status
    def initialize(status:, record:)
      @status = status
      @record = record
    end

    def created?
      @status == :created
    end

    def updated?
      @status == :updated
    end

    def deleted?
      @status == :deleted
    end
  end



  def say msg 
    return unless Rails.env.development?
    Rails.logger.info '--------------------------------------------------------'
    Rails.logger.info msg
    Rails.logger.info '--------------------------------------------------------'
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
