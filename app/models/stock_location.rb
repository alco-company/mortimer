class StockLocation < AbstractResource
  include Assetable

  belongs_to :stock
  has_many :stock_items
  has_many :stock_transactions, inverse_of: :stock_location

  def self.default_scope
    StockLocation.all.joins(:asset)
  end

  def combo_values_for_stock_id 
    return [{id: nil, name: ''}] if stock.nil?
    [{id: stock.id, name: stock.name}]
  end
  
  def self.get_by field, s, parm 
    self.find_by(field => parm["location"]) || self.create_for_stock_transaction( s, parm)
  end
  
  def self.create_for_stock_transaction s, parm
    begin      
      acc = s.account
      Asset.create( 
        account_id: acc.id, 
        name: parm["location"], 
        assetable: StockLocation.create( 
          stock_id: s.id, 
          location_barcode: parm["location"] 
        ) 
      ).assetable
    rescue => exception
      raise ActiveRecord::Rollback
      nil
    end
  end


  def nbr_pallets
    return 0 if stock_transactions.empty?
    q = stock_transactions.pluck :state
    p = 0
    q.each{ |s| case s when 'RECEIVE'; p+=1 when 'SHIP'; p-=1 end } if q.any?
    p
  rescue
    0
  end

  def quantity
    st = stock_transactions.pluck( :state, :quantity).compact
    qt = 0
    st.each{ |s,q| case s when 'RECEIVE'; qt+=q when 'SHIP'; qt-=(q||0) end } if st.any?
    qt
  end

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    StockLocation.all.joins(:asset)
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
  # Employees - if updated without the asset being 'called'
  #
  def broadcast_update
    if self.asset.deleted_at.nil? 
      broadcast_replace_later_to 'stock_locations', partial: self, target: self, locals: { resource: self }
    else 
      broadcast_remove_to 'stock_locations', target: self
    end
  end

  def broadcast_destroy
    raise "StockLocations should not be hard-deleteable!"
    #after_destroy_commit { broadcast_remove_to self, partial: self, locals: {resource: self} }
  end
  #
end