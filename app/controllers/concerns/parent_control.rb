require 'active_support/concern'

module ParentControl
  extend ActiveSupport::Concern

  included do
    # before_action :set_parents, only: [ :new, :edit, :show ]
    # after_action :update_parenthood, only: [:create,:update,:destroy]
    before_action :set_ancestry, only: [:create, :update]
  end

  def parent
    @parent ||= find_parent
  end


  def parent_class
    @parent_class ||= @parent.class
  end

  def parent_class= val
    @parent_class = val
  end

  def parent?
    !(%w{NilClass TrueClass FalseClass}.include? parent.class.to_s)
  end

  #
  # parent_url returns the parent url - /employees/1
  def parent_url options={}
    parent? ? url_for(parent) : ""
    # parent? ? ( "/%s/%s" % [ @parent.class.table_name, @parent.id ] ) : ""
  end


  #
  # build an array of the resource - particular to <SELECT>
  def set_parents
    @parents = []
    return @parents unless resource_class.respond_to? :roots #( 'arraying') && resource? )
    @parents = resource_class.arraying({ order: 'name'}, resource.possible_parents)
  end


  #
  #
  # /employees/1/teams
  # /employees/1/teams/5
  # /employees/1/teams/5/attach
  # /theatres/2/contacts/5/uris.js
  def find_parent path=nil, parms=nil
    parms ||= params
    return (parms[:parent].classify.constantize.find(parms[:parent_id])) if parms[:parent] && parms[:parent_id]
    path ||= request.path
    paths=path.split("/")
    paths.shift if paths[0]==""
    return nil if paths.size < 3
    paths.pop if %w{new edit show create update delete index attach detach prefer defer activate deactivate print clonez modal}.include? paths[-1].split(".")[0]
    return nil if (paths.size < 3)
    p0 = paths[0].singularize.classify.constantize.find(paths[1])
    return p0 if paths.size < 5
    p1 = paths[2].singularize.classify.constantize.find(paths[3])
    return p1 if paths.size == 5 and parent_reflections(p1, paths[4])
    p0
    # return paths[0].singularize.classify.constantize.find(paths[1])
  rescue
    nil
    # elems = Rails.application.routes.recognize_path path
    # return nil if
    # recognise_path paths.join("/")
  end

  def parent_reflections p, e 
    return true if p._reflections.keys.include? e.to_s
    false 
  end


  #
  # ['theatres','5','contacts','2','uris.js']
  def recognise_path path
    path_elements = Rails.application.routes.recognize_path( path.gsub( /\..*$/,''))   # "/admin/users/2/printers/3/attach" => {:controller=>"printers", :action=>"attach", :user_id=>"2", :id=>"3"}
    recognise_parent( recognise_resource( path_elements ) )
  rescue Exception => e
    redirect_to root_url if e.class.to_s == "ActionController::RoutingError"
    nil
  end

  # {:controller=>"printers", :action=>"attach", :user_id=>"2", :id=>"3"}
  def recognise_resource elems
    @parent_resource_class = elems.delete(:controller).singularize.classify.constantize
    @parent_resource = @parent_resource_class.find( elems.delete(:id) )
    elems
  rescue Exception => e
    return elems if e.class.to_s == "ActiveRecord::RecordNotFound"
    @parent_resource_class = nil
    elems
  end

  # { :action=>"attach", :user_id=>"2" }
  def recognise_parent elems
    elems.delete :action
    arr = elems.keys.first.to_s.split("_")
    return nil unless arr.include? "id"
    arr.pop
    arr.join("_").singularize.classify.constantize.find(elems.values.first)
  rescue
    nil
  end

  #
  # # /employees/1/teams/new
  # # /employees/1/teams/1/edit
  # # /employees/1/teams/1/delete
  def update_parenthood
    # this is not battle tested yet - whd 20190124
    return true

    if params[:parent] and params[:parent_id]
      # raise "Ups - is this ready for prime time yet?"
      parent = params[:parent].classify.constantize.find(params[:parent_id])
      unless parent.blank?
        case params[:action]
        when "create"
          children = eval("parent.#{resources_name}")
          children << resource unless children.include? resource
        # when "edit"
        when "delete"
          children = eval("parent.#{resources_name}")
          children >> resource
        end
      end
    end
    true
  rescue
    false
  end
  #
  #


  #
  # update resource.parent if params[resource_symbol][:ancestry] is present
  # 
  #
  def set_ancestry
    if resource.respond_to?(:parent) and !params[resource_symbol][:ancestry].blank?
      a = params[resource_symbol][:ancestry]
      a = (a.split(" ").count > 1) ? (a.split(" ").last) : a
      resource.parent = resource_class.find( a)
      # resource.update_attribute :parent, resource_class.find( a)
    end
  rescue
    nil
  end


    #
    # picked up from abstract_resources_controller.rb - whd 20/05/2022
    #
    # #
    # # update resource.parent if params[:resource_symbol][:ancestry] is present
    # # 
    # #
    # def set_ancestry
    #   unless params[resource_symbol][:ancestry].blank?
    #     resource.parent = resource_class.find params[resource_symbol][:ancestry]
    #   end
    # rescue
    #   nil
    # end



end
