class Product < AbstractResource
  include Assetable

  belongs_to :supplier
  has_many :stocked_products, dependent: :destroy
  has_many :stock_locations, through: :stocked_products
  has_many :stock_item_transactions, through: :stocked_products

  def self.default_scope
    Product.all.joins(:asset)
  end

  def self.get_by field, s, parm 
    self.find_by(field => parm["ean14"]) || self.create_for_stock_item_transaction( s, parm)
  end

  def self.create_for_stock_item_transaction s, parm 
    acc = s.account
    sup = Supplier.create_for_product(acc, parm)
    prod = Product.create!( supplier: sup, supplier_barcode: parm["ean14"] )
    a= Asset.create!( 
      account_id: acc.id, 
      name: parm["ean14"], 
      assetable: prod
    )
    say "asset id: #{a.id}"
    Product.find a.assetable.id
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
  
  def get_stocked_product s, sl, prod, parm
    sp = prod.stocked_products.where(stock: s).first 
    if sp.nil?
      sp = StockedProduct.create_for_stock_item_transaction( s, prod, sl, parm)
    end
    sp
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
    st.each{ |s,q| case s when 'RECEIVE'; qt+=q when 'SHIP'; qt-=(q||0) end } if st.any?
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
      broadcast_replace_later_to 'products', partial: self, target: self, locals: { resource: self }
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
