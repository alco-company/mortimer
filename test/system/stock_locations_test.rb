require "application_system_test_case"

class StockLocationsTest < ApplicationSystemTestCase
  setup do
    @stock_location = stock_locations(:one)
  end

  test "visiting the index" do
    visit stock_locations_url
    assert_selector "h1", text: "Stock locations"
  end

  test "should create stock location" do
    visit stock_locations_url
    click_on "New stock location"

    fill_in "Location barcode", with: @stock_location.location_barcode
    check "Open shelf" if @stock_location.open_shelf
    fill_in "Shelf size", with: @stock_location.shelf_size
    fill_in "Stock", with: @stock_location.stock_id
    click_on "Create Stock location"

    assert_text "Stock location was successfully created"
    click_on "Back"
  end

  test "should update Stock location" do
    visit stock_location_url(@stock_location)
    click_on "Edit this stock location", match: :first

    fill_in "Location barcode", with: @stock_location.location_barcode
    check "Open shelf" if @stock_location.open_shelf
    fill_in "Shelf size", with: @stock_location.shelf_size
    fill_in "Stock", with: @stock_location.stock_id
    click_on "Update Stock location"

    assert_text "Stock location was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock location" do
    visit stock_location_url(@stock_location)
    click_on "Destroy this stock location", match: :first

    assert_text "Stock location was successfully destroyed"
  end
end
