class Asset < AbstractResource
  has_ancestry
  
  belongs_to :account, inverse_of: :assets
  belongs_to :calendar, optional: true

  delegated_type :assetable, types: %w[ Employee Product Stock StockLocation PunchClock ], dependent: :destroy
  accepts_nested_attributes_for :assetable

  #
  # called by resource_control when creating new resources
  # for the #new action
  def self.new_rec r
    self.new assetable: r.new
  end
  

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    where(deleted_at: nil, account: Current.account)
  end


  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_create
    broadcast_prepend_later_to self.assetable_type.underscore.pluralize, target: "#{self.assetable_class.to_s.underscore}_list", partial: self.assetable, locals: { resource: self.assetable }
  end
  
  
  #
  # will be called by "children" too - like Employees, Stocks, StockLocations, etc
  #
  def broadcast_update
    if self.deleted_at.nil? 
      broadcast_replace_later_to self.assetable_type.underscore.pluralize, partial: self.assetable, target: self.assetable, locals: { resource: self.assetable }
    else 
      broadcast_remove_to self.assetable_type.underscore.pluralize, target: self.assetable
    end
  end


  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end


end
