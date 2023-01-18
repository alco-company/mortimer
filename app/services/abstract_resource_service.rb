#
# Most resources are easily inserted
# and will return a Result hash with 
# a status and a record persisting the
# ActiveRecord
#
# upsert, create and update and delete
# usually will be called from the controller
# and will return a Result hash with a status
#
class AbstractResourceService

  def upsert( resource, resource_params )
    resource.new_record? ? create(resource) : update(resource, resource_params)
  end

  def create( resource )
    begin
      resource.save
      Result.new record: resource, status: :created
      
    rescue Exception => exception
      ActiveRecord::Base.connection.execute 'ROLLBACK' 
      Result.new status: :error, record: resource      
    end
  end
  
  def update( resource, resource_params )
    begin        
      resource.update resource_params 
      Result.new record: resource, status: :updated

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
  # some (few) resources may be deleted permanently (if they do not respond_to?(:deleted_at) )
  # or if the resource_params[:purge] is set to true
  #
  def delete( resource, resource_params )
    begin        
      if resource_params[:purge].blank? && resource.respond_to?(:deleted_at)
        resource.update_attribute :deleted_at, DateTime.current
      else
        resource.destroy
      end
      Result.new record: resource, status: :deleted

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
      case status
      when :created; @status = record.valid? ? :created : :not_valid
      when :updated; @status = record.valid? ? :updated : :not_valid 
      when :deleted; @status = (record.destroyed? || !record.deleted_at.nil?) ? :deleted : :not_valid
      end
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