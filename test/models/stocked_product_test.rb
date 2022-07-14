require "test_helper"

class StockedProductTest < ActiveSupport::TestCase

  def setup 
    @account = accounts(:one)
    Current.account = @account
  end

  test "create a StockedProduct" do
    parm = {  "location" => "1100", "ean14" => "05711234101214", "batchnbr" => "123124", "unit" => "packet" }
    s = stocks(:one)
    prod = ProductService.new.create_product s, parm
    sl = StockLocationService.new.create_stock_location s, parm
    sp = StockedProductService.new.create_stocked_product s, prod, sl, parm

    assert sp.stock_unit, "packet" 
  end


  # test "find by location" do
  #   parm = { "location" => "1100"}
  #   s = stocks(:one)
  #   loc = StockLocationService.new.create_stock_location s, parm
  #   result = StockLocationService.new.get_by :location_barcode, s, parm
  #   assert result.location_barcode, "1100"
  # end

end
