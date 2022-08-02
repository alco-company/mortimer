require "test_helper"

#
# http://www.barcode-generator.org/
#
# Product barcode
# Application Identifiers:
#
# AI 15 - best-before -  15220502
# AI 02 - ean14 -        0205700426101019
# AI 37 - quantity -     3725
#
# Pallet barcode
# AI 00 - SSCS -         00123456789012345678
# AI 10 - batch number - 10100100
#
# 1522050202057104261010293725  91100
# 0012345678901234567510123457
# 0012345678901234567610123457
# 0012345678901234567710123457
# 0012345678901234567810123457
# 0012345678901234567910123457
 
# 1522061002057114261010293725  91101
# 0012345678901234567010007
# 0012345678901234567110007
# 0012345678901234567210007
# 0012345678901234567310007
# 0012345678901234567410007
#
# 1522061002057204261010293725  91102
# 00123456789012345650100000007
#
# 1522061002057204271010293725  91102
# 00123456789012345651100000007
#
# 1522061002057204271011293725  91102
# 00123456789012345651100000007
# 00123456789012345652100000007
# 00123456789012345653100000007
# 00123456789012345654100000007 91103
# 00123456789012345655100000007 91105
# 00123456789012345656100000007 91105
#

#
# 9504028491401065152208251005011000310273
# 003590024060386239573302025050
# 02040284914110643796
#

class StockItemTransactionTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    @asset = Asset.create! account: accounts(:one), name: 'Stock', assetable: Stock.create 
    # @asset = Asset.create account: accounts(:one), name: "Stock 1", assetable: stocks(:one)
    @resource_params = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345678", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
  end

  # Parameters: {"stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345678", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"3"}
  test "the correct params being delivered" do 
    assert @resource_params == {"stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345678", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}"}
  end

  test "create a POS StockItemTransaction" do 
    assert_difference( 'StockItemTransaction.count', 1) do
      StockItemTransactionService.new.create_pos_transaction @resource_params
    end  
  end

  test "deleting a POS StockItemTransaction" do
    @st = StockItemTransactionService.new.create_pos_transaction @resource_params
    params = {id: "#{@st.id}"}
    assert_difference( 'Event.count', -1) do
      StockItemTransactionService.new.delete_pos_transaction params
    end  
  end

  test "create two POS StockItemTransaction on an existing StockItem" do
    StockItemTransactionService.new.create_pos_transaction @resource_params
    resource_params2 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345677", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    resource_params3 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345676", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    assert_difference( 'StockItem.count', 0) do
      StockItemTransactionService.new.create_pos_transaction resource_params2
      @st = StockItemTransactionService.new.create_pos_transaction resource_params3
    end  
    assert_equal( 75, @st.stock_item.quantity)
  end

  test "RECEIVE 75 and SHIP 25" do
    resource_params25 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345678", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    StockItemTransactionService.new.create_pos_transaction resource_params25
    resource_params25 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567710445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345677", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    StockItemTransactionService.new.create_pos_transaction resource_params25
    resource_params25 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567610445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345676", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    StockItemTransactionService.new.create_pos_transaction resource_params25
    resource_params25 = { "stock_item_transaction"=>{"barcode"=>"0012345678901234567710445566", "left"=>"", "sscs"=>"123456789012345677", "batchnbr"=>"445566", "direction"=>"SHIP", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"#{@asset.assetable.id}" }
    @st = StockItemTransactionService.new.create_pos_transaction resource_params25
    assert_equal( 50,@st.stock_item.quantity)
  end



end
