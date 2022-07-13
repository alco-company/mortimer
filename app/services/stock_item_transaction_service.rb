class StockItemTransactionService < EventService
  def create( resource, resource_class )
    result = super(resource)
    if result.status != :created 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end

  def update( resource, resource_params, resource_class )
    result = super(resource,resource_params)
    if result.status != :updated 
      resource.assetable = resource_class.new if resource.assetable.nil?
    end
    result
  end
    
  def create_pos_transaction params
    parm=params["stock_item_transaction"]
    s = Stock.unscoped.find(params["stock_id"])
    case parm["direction"]
    when "RECEIVE"; create_adding_transaction(s, parm)
    when "SHIP","SCRAP"; create_subtracting_transaction( s, parm)
    when "INVENTORY"; create_inventory_transaction(s, parm)
    else raise "direction parameter (#{parms["direction"]}) is not implemented!"
    end
  rescue RuntimeError => err
    Rails.logger.info "[stock_item_transaction] Error: (StockItemTransaction) #{err.message}"
    false
  end
  
  def delete_pos_transaction params 
    st=StockItemTransaction.unscoped.find(params[:id])
    return false unless st and st.event.update(deleted_at: DateTime.current)
    true
  end
  
  def create_adding_transaction s, parm 
    StockItemTransaction.transaction do
      Current.account = Asset.unscoped.where(assetable: s).first.account
      Rails.logger.info "----> Current.account #{Current.account.to_json}"
      begin 
        prod = ProductService.new.get_by :supplier_barcode, s, parm
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
  
  def create_subtracting_transaction s, parm 
    StockItemTransaction.transaction do
      Current.account = Asset.where(assetable: s).first.account
      begin
        st = Event.unscoped.where( name: parm["sscs"], state: "RECEIVE" ).last.eventable  
        si = StockItem.subtract_quantity( s, st, parm)
        self.create_transaction s, st.stock_location, st.stocked_product, si, parm, st.quantity, st.unit
      end
    end
  end
  
  def create_inventory_transaction(s, parm)
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
      say "----> StockItemTransaction (event) #{e.to_json}"
      say "----> StockItemTransaction #{e.eventable.to_json}"
      sp.update_attribute :updated_at, DateTime.current
      e.eventable
    rescue => err 
      Rails.logger.info "[stock_item_transaction] create_transaction: (#{err})"
      raise ActiveRecord::Rollback
      nil
    end
  end

end