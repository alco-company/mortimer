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

    assert si.quantity, sp.quantity

    parm = { "nbrcont" => "25", "sell" => "220505", "location" => "1101", "ean14" => "05711234101214", "batchnbr" => "123124", "unit" => "packet" }
    # prod = ProductService.new.create_product s, parm
    prod = ProductService.new.get_by :supplier_barcode, s, parm
    # sl = StockLocationService.new.create_stock_location s, parm
    sl = StockLocationService.new.get_by :location_barcode, s, parm
    sp = ProductService.new.get_stocked_product s, sl, prod, parm
    si = StockItemService.new.add_quantity( s, sp, sl, parm)

    assert si.quantity, (sp.quantity - 25)

    parm = { "nbrcont" => "25", "sell" => "220505", "location" => "1100", "ean14" => "05711234101225", "batchnbr" => "123124", "unit" => "packet" }
    prod = ProductService.new.create_product s, parm
    sl = StockLocationService.new.create_stock_location s, parm
    sp = StockedProductService.new.create_stocked_product s, prod, sl, parm
    si = StockItemService.new.add_quantity( s, sp, sl, parm)

    assert si.quantity, sp.quantity
    assert StockItem.unscoped.count, 3
    
  end

end
