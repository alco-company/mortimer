require "application_system_test_case"

class StockedProductsTest < ApplicationSystemTestCase
  setup do
    @stocked_product = stocked_products(:one)
  end

  test "visiting the index" do
    visit stocked_products_url
    assert_selector "h1", text: "Stocked products"
  end

  test "should create stocked product" do
    visit stocked_products_url
    click_on "New stocked product"

    fill_in "Product", with: @stocked_product.product_id
    fill_in "Quantity", with: @stocked_product.quantity
    fill_in "Stock", with: @stocked_product.stock_id
    fill_in "Stock location", with: @stocked_product.stock_location_id
    fill_in "Stock unit", with: @stocked_product.stock_unit
    click_on "Create Stocked product"

    assert_text "Stocked product was successfully created"
    click_on "Back"
  end

  test "should update Stocked product" do
    visit stocked_product_url(@stocked_product)
    click_on "Edit this stocked product", match: :first

    fill_in "Product", with: @stocked_product.product_id
    fill_in "Quantity", with: @stocked_product.quantity
    fill_in "Stock", with: @stocked_product.stock_id
    fill_in "Stock location", with: @stocked_product.stock_location_id
    fill_in "Stock unit", with: @stocked_product.stock_unit
    click_on "Update Stocked product"

    assert_text "Stocked product was successfully updated"
    click_on "Back"
  end

  test "should destroy Stocked product" do
    visit stocked_product_url(@stocked_product)
    click_on "Destroy this stocked product", match: :first

    assert_text "Stocked product was successfully destroyed"
  end
end
