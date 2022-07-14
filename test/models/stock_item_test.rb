require "test_helper"

class StockItemTest < ActiveSupport::TestCase

  def setup 
    @account = accounts(:one)
    Current.account = @account
  end

  test "create a StockItem" do
    parm = { "nbrcont" => "25", "sell" => "220505", "location" => "1100", "ean14" => "05711234101214", "batchnbr" => "123124", "unit" => "packet" }
    s = stocks(:one)
    prod = ProductService.new.create_product s, parm
    sl = StockLocationService.new.create_stock_location s, parm
    sp = StockedProductService.new.create_stocked_product s, prod, sl, parm
    si = StockItemService.new.add_quantity( s, sp, sl, parm)

    assert si.quantity, 25 
  end

end
