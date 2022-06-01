class Stock  < AbstractResource
  include Assetable
  
  has_secure_token :access_token

  has_many :stock_locations
  has_many :stocked_products
  has_many :stock_transactions, through: :stock_locations
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Stock.all.joins(:asset)
  end

  def nbr_pallets
    q = stock_transactions.pluck :state
    p = 0
    q.each{ |s| case s when 'RECEIVE'; p+=1 when 'SHIP'; p-=1 end } if q.any?
    p
  end

  def quantity
    st = stock_transactions.pluck( :state, :quantity).compact
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
      broadcast_replace_later_to 'stocks', partial: self, target: self, locals: { resource: self }
    else 
      broadcast_remove_to 'stocks', target: self
    end
  end

  def broadcast_destroy
    raise "Stocks should not be hard-deleteable!"
    #after_destroy_commit { broadcast_remove_to self, partial: self, locals: {resource: self} }
  end
  #
  #
end
