class ContactsController  < ParticipantsController

  def set_resource_class
    @resource_class= Contact
  end

  def new_resource
    
    r = resource_class.new.respond_to?( :delegated_from ) ? resource_class.delegated_from  : resource_class
    return r.new_rec(resource_class) unless (params.include? r.to_s.underscore)

    p = resource_params
    emp = p[:participantable_attributes].delete :employer
    emp = ParticipantService.new.get_by( :name, emp, {name: emp}, Organization) if emp
    p=p.compact.first if p.class==Array
    rr= r.ancestors.include?( ActiveRecord::Base) ? r.new(p) : r.new
    rr.participantable.employer = emp
    rr
  rescue => err
    raise "new_resource failed due to #{err}"
  end


  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params[:participant][:participantable_attributes] ||= {}
      # params[:participant][:participantable_attributes][:task_id] = 0
      params.require(:participant).permit(:participantable_type, :name, :account_id, participantable_attributes: [ :id, :job_title, :employer ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Team.search Team.all, params[:q].downcase
    end

end
