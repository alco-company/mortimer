require "application_system_test_case"

class StockItemsTest < ApplicationSystemTestCase
  setup do
    @stock_item = stock_items(:one)
  end

  test "visiting the index" do
    visit stock_items_url
    assert_selector "h1", text: "Stock items"
  end

  test "should create stock item" do
    visit stock_items_url
    click_on "New stock item"

    fill_in "Batch number", with: @stock_item.batch_number
    fill_in "Batch unit", with: @stock_item.batch_unit
    fill_in "Expire at", with: @stock_item.expire_at
    fill_in "Quantity", with: @stock_item.quantity
    fill_in "Stock", with: @stock_item.stock_id
    fill_in "Stocked location", with: @stock_item.stock_location_id
    fill_in "Stocked product", with: @stock_item.stocked_product_id
    click_on "Create Stock item"

    assert_text "Stock item was successfully created"
    click_on "Back"
  end

  test "should update Stock item" do
    visit stock_item_url(@stock_item)
    click_on "Edit this stock item", match: :first

    fill_in "Batch number", with: @stock_item.batch_number
    fill_in "Batch unit", with: @stock_item.batch_unit
    fill_in "Expire at", with: @stock_item.expire_at
    fill_in "Quantity", with: @stock_item.quantity
    fill_in "Stock", with: @stock_item.stock_id
    fill_in "Stocked location", with: @stock_item.stock_location_id
    fill_in "Stocked product", with: @stock_item.stocked_product_id
    click_on "Update Stock item"

    assert_text "Stock item was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock item" do
    visit stock_item_url(@stock_item)
    click_on "Destroy this stock item", match: :first

    assert_text "Stock item was successfully destroyed"
  end
end
