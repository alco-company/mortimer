class Product < AbstractResource
  include Assetable

  belongs_to :supplier, class_name: "Organization", optional: true
  has_many :stocked_products, dependent: :destroy
  has_many :stock_locations, through: :stocked_products
  has_many :stock_item_transactions, through: :stocked_products

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' "
  end

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("assetable" deleted_at: nil)
    Product.all.joins(:asset)
  end

  def combo_values_for_supplier_id 
    return [{id: nil, name: ''}] if supplier.nil?
    [{id: supplier.id, name: supplier.name}]
  end

  def nbr_pallets
    q = stock_item_transactions.pluck :state
    p = 0
    q.each{ |s| case s when 'RECEIVE'; p+=1 when 'SHIP'; p-=1 end } if q.any?
    p
  end

  def quantity
    st = stock_item_transactions.pluck( :state, :quantity).compact
    qt = 0
    st.each{ |s,q| case s when 'RECEIVE'; qt+=(q||0) when 'SHIP'; qt-=(q||0) end } if st.any?
    qt
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end
    
  #
  # Stocks - if updated without the asset being 'called'
  #
  def broadcast_update
    if self.asset.deleted_at.nil? 
      broadcast_replace_later_to 'products', 
        partial: self, 
        target: self, 
        locals: { resource: self, user: Current.user }
    else 
      broadcast_remove_to 'products', target: self
    end
  end

  def broadcast_destroy
    raise "Products should not be hard-deleteable!"
    #after_destroy_commit { broadcast_remove_to self, partial: self, locals: {resource: self} }
  end
  #
  #
end
