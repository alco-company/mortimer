require "test_helper"

class StockLocationTest < ActiveSupport::TestCase

  def setup 
    @account = accounts(:one)
    Current.account = @account
  end

  test "create a StockLocation" do
    parm = { "location" => "1100"}
    s = stocks(:one)
    loc = StockLocationService.new.create_stock_location s, parm

    assert loc.location_barcode, "1100" 
  end


  test "find by location" do
    parm = { "location" => "1100"}
    s = stocks(:one)
    loc = StockLocationService.new.create_stock_location s, parm
    result = StockLocationService.new.get_by :location_barcode, s, parm
    assert result.location_barcode, "1100"
  end

end
