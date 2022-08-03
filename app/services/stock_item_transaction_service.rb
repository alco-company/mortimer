class StockItemTransactionService < EventService
    
  def create_pos_transaction params
    parm=params["stock_item_transaction"]
    s = Stock.unscoped.find(params["stock_id"])
    set_current_data s
    case parm["direction"]
    when "RECEIVE"; create_adding_transaction(s, parm)
    when "SHIP","SCRAP"; create_subtracting_transaction( s, parm)
    when "INVENTORY"; create_inventory_transaction(s, parm)
    else raise "direction parameter (#{parms["direction"]}) is not implemented!"
    end
  rescue RuntimeError => err
    Rails.logger.info "[stock_item_transaction] Error: (StockItemTransaction) #{err.message}"
  end
  
  # id is the stock_item_transaction
  def delete_pos_transaction params 
    st=StockItemTransaction.unscoped.find(params[:id])
    return false unless st
    delete(st.event).deleted?
  end
  
  def create_adding_transaction s, parm 
    StockItemTransaction.transaction do
      begin 
        # get the product asset
        asset_prod = ProductService.new.get_by :supplier_barcode, s, parm
        # say "----> Product #{asset_prod.assetable.to_json}"
        sl = StockLocationService.new.get_by :location_barcode, s, parm
        # say "----> StockLocation #{sl.to_json}"
        sp = ProductService.new.get_stocked_product s, sl, asset_prod, parm
        # say "----> StockedProduct #{sp.to_json}"
        si = StockItemService.new.add_quantity( s, sp, sl, parm)
        # say "----> StockItem #{si.to_json}"
        create_transaction s, sl, sp, si, parm, parm["nbrcont"], parm["unit"]
      rescue RuntimeError => err
        Rails.logger.info "[stock_item_transaction] create_adding_transaction: (#{err})"
        raise ActiveRecord::Rollback
      end    
    end
  end
  
  def create_subtracting_transaction s, parm 
    StockItemTransaction.transaction do
      begin
        sit = Event.unscoped.where( name: parm["sscs"], state: "RECEIVE" ).last
        unless sit 
          sit = StockItemTransaction.new stock_location: StockLocation.new, stocked_product: StockedProduct.new( id: nil ), quantity: 0, unit: 'missing'
          si = StockItem.new
        else 
          sit = sit.eventable  
          si = StockItemService.new.subtract_quantity( s, sit, parm)
        end
        create_transaction s, sit.stock_location, sit.stocked_product, si, parm, sit.quantity, sit.unit
      rescue RuntimeError => err
        Rails.logger.info "[stock_item_transaction] create_subtracting_transaction: (#{err})"
        raise ActiveRecord::Rollback
      end
    end
  end
  
  def create_inventory_transaction(s, parm)
    StockItemTransaction.transaction do
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
  def create_transaction s, sl, sp, si, parm, q, u
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
      sp.update_attribute :updated_at, DateTime.current
      e.eventable
    rescue => err 
      Rails.logger.info "[stock_item_transaction] create_transaction: (#{err})"
      raise ActiveRecord::Rollback
    end
  end

  def set_current_data stock 
    Current.account ||= Asset.unscoped.where(assetable: stock).first.account
    Current.user ||= (Current.account.users.first || User.unscoped.first)
  end

end