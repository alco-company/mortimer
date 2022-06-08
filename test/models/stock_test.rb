require "test_helper"

class StockTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    @asset = Asset.create! account: accounts(:one), name: 'Stock', assetable: Stock.create 
    # @asset = Asset.create account: accounts(:one), name: "Stock 1", assetable: stocks(:one)
    @resource_params = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345678", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
  end

  test "stock/:id/stock_item_transactions should list 3 transactions" do
    StockItemTransaction.create_pos_transaction @resource_params
    resource_params2 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345677", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    resource_params3 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345676", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    StockItemTransaction.create_pos_transaction resource_params2
    StockItemTransaction.create_pos_transaction resource_params3
    assert_equal( 3, @asset.assetable.stock_item_transactions.count)    
  end

end
