require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "create a product" do
    parm = { "ean14" => "05711234123451"}
    s = stocks(:one)
    prod = ProductService.new.create_product s, parm 

    assert prod.supplier_barcode, "1234" 
  end

end
