require "test_helper"

class SupplierTest < ActiveSupport::TestCase

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

  test "find existing Supplier - create if necessary" do
    part = Participant.create name: "1234", account: @account, participantable: Supplier.new( gtin_prefix: "1234")
    parm = { "ean14" => "05711234123451" }
    acc = @account
    result = Supplier.find_by_prefix "05711234123451"
    assert result.gtin_prefix, "1234"
    
    result = SupplierService.new.get_by :gtin_prefix, acc, parm
    assert result.gtin_prefix, "1234"
    assert Supplier.count,1

    parm = { "ean14" => "05711235123451"}
    result = SupplierService.new.get_by :gtin_prefix, acc, parm
    assert result.gtin_prefix, "1235" 
    assert Supplier.count,2

  end
end
