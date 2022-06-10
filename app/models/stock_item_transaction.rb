
#
# StockItemTransaction have only a few states
# RECEIVE - adding units to the current stock
# SHIP - subtracting units from the current stock
# INVENTORY - sum the current units 
# SCRAP - a special kind of subtracting units
#
class StockItemTransaction  < AbstractResource
  include Eventable

  belongs_to :stocked_product
  belongs_to :stock_location
  belongs_to :stock_item

  def self.default_scope
    StockItemTransaction.all.joins(:event)
  end
    
  def self.create_pos_transaction params
    parm=params["stock_item_transaction"]
    s = Stock.unscoped.find(params["stock_id"])
    case parm["direction"]
    when "RECEIVE"; self.create_adding_transaction(s, parm)
    when "SHIP","SCRAP"; self.create_subtracting_transaction( s, parm)
    when "INVENTORY"; self.create_inventory_transaction(s, parm)
    else raise "direction parameter (#{parms["direction"]}) is not implemented!"
    end
  rescue RuntimeError => err
    Rails.logger.info "[stock_item_transaction] Error: (StockItemTransaction) #{err.message}"
    false
  end
  
  def self.delete_pos_transaction params 
    st=StockItemTransaction.unscoped.find(params[:id])
    return false unless st and st.event.update(deleted_at: DateTime.now)
    true
  end
  
  private 
  
  def self.create_adding_transaction s, parm 
    StockItemTransaction.transaction do
      Current.account = Asset.unscoped.where(assetable: s).first.account
      Rails.logger.info "----> Current.account #{Current.account.to_json}"
      begin 
        prod = Product.unscoped.get_by :supplier_barcode, s, parm
        say "----> Product #{prod.to_json}"
        sl = StockLocation.unscoped.get_by :location_barcode, s, parm
        say "----> StockLocation #{sl.to_json}"
        sp = prod.get_stocked_product s, sl, prod, parm
        say "----> StockedProduct #{sp.to_json}"
        si = StockItem.add_quantity( s, sp, sl, parm)
        say "----> StockItem #{si.to_json}"
        self.create_transaction s, sl, sp, si, parm, parm["nbrcont"], parm["unit"]
      rescue ActiveRecord::StatementInvalid
        Rails.logger.info "[stock_item_transaction] create_adding_transaction: (StatementInvalid)"
        raise ActiveRecord::Rollback
        false
      end    
    end
  end
  
  def self.create_subtracting_transaction s, parm 
    StockItemTransaction.transaction do
      Current.account = Asset.where(assetable: s).first.account
      begin
        st = Event.unscoped.where( name: parm["sscs"], state: "RECEIVE" ).last.eventable  
        si = StockItem.subtract_quantity( s, st, parm)
        self.create_transaction s, st.stock_location, st.stocked_product, si, parm, st.quantity, st.unit
      end
    end
  end
  
  def self.create_inventory_transaction(s, parm)
    StockItemTransaction.transaction do
      Current.account = Asset.where(assetable: s).first.account
      begin
        st = Event.unscoped.where( name: parm["sscs"] ).last.eventable
        self.create_transaction s, st.stock_location, st.stocked_product, si, parm
      rescue => error
        Rails.logger.info "[stock_item_transaction] create_inventory_transaction: (#{error})"
      end
    end
  end

  # create_transaction: (PG::NotNullViolation: ERROR:  null value in column "calendar_id" of relation "events" violates not-null constraint
  # 2022-06-09T13:20:45.729958238Z app[worker.1]: DETAIL:  Failing row contains (1, 2, StockItemTransaction, 1, null, 123456789012345675, RECEIVE, null, null, null, null, null, null, 2022-06-09 13:20:45.725922, 2022-06-09 13:20:45.725922).
  def self.create_transaction s, sl, sp, si, parm, q, u
      begin
        acc = s.account
        e = Event.create( 
          account_id: acc.id, 
          # depending upon the Stock.stock_unit_identifier name: parm["ean14"], 
          name: parm["sscs"], # identifier = sscs -> pallet
          state: parm["direction"], 
          calendar_id: s.calendar || acc.calendar,
          eventable: StockItemTransaction.create( 
            barcodes: parm["barcode"], 
            stocked_product_id: sp.id, 
            stock_location_id: sl.id, 
            stock_item_id: si.id, 
            quantity: q, 
            unit: u
          ) 
        )
        say "----> StockItemTransaction (event) #{e.to_json}"
        say "----> StockItemTransaction #{e.eventable.to_json}"
        sp.update_attribute :updated_at, DateTime.now
        e.eventable
      rescue => err 
        Rails.logger.info "[stock_item_transaction] create_transaction: (#{err})"
        raise ActiveRecord::Rollback
        nil
      end
    end

    # 
    # methods supporting broadcasting 
    #
    def broadcast_create
      say "----> broadcast (self) #{self.to_json}"
      broadcast_prepend_later_to model_name.plural, target: "#{self.class.to_s.underscore}_list", partial: self, locals: { resource: self }
      broadcast_prepend_later_to "pos_stock_item_transactions", target: "pos_stock_item_transaction_list", partial: "pos/stock_item_transactions/stock_item_transaction", locals: { resource: self }
    end

end
