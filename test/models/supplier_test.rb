require "test_helper"

class SupplierTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup 
    @account = accounts(:one)
    Current.account = @account
  end

  test "create a supplier for a product" do
    parm = { "ean14" => "05711234123451"}
    acc = @account
    sup = SupplierService.new.create_for_product acc, parm 

    assert sup.gtin_prefix, "1234" 
  end

  test "find by gtin_prefix" do
    part = Participant.create name: "1234", account: @account, participantable: Supplier.new( gtin_prefix: "1234")
    barcode = "05711234123451"
    result = Supplier.find_by_prefix "05711234123451"
    assert result.gtin_prefix, "1234"
  end

  test "find existing Supplier" do
    part = Participant.create name: "1234", account: @account, participantable: Supplier.new( gtin_prefix: "1234")
    parm = { "ean14" => "05711234123451" }
    acc = @account
    result = Supplier.find_by_prefix "05711234123451"
    assert result.gtin_prefix, "1234"

    parm = { "ean14" => "05711235123451"}
    sup = SupplierService.new.create_for_product acc, parm 
    assert sup.gtin_prefix, "1235" 

    result = SupplierService.new.get_by :gtin_prefix, acc, parm
    puts result.to_json
  #   unless result 
  #     sup = SupplierService.new.create_for_product acc, parm 
  #     sup = SupplierService.new.find_by :gtin_prefix, acc, parm
  #     assert sup.gtin_prefix, "1234"
  #   end
  end
end
