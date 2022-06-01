require "test_helper"

class StockLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_location = stock_locations(:one)
  end

  test "should get index" do
    get stock_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_location_url
    assert_response :success
  end

  test "should create stock_location" do
    assert_difference("StockLocation.count") do
      post stock_locations_url, params: { stock_location: { location_barcode: @stock_location.location_barcode, open_shelf: @stock_location.open_shelf, shelf_size: @stock_location.shelf_size, stock_id: @stock_location.stock_id } }
    end

    assert_redirected_to stock_location_url(StockLocation.last)
  end

  test "should show stock_location" do
    get stock_location_url(@stock_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_location_url(@stock_location)
    assert_response :success
  end

  test "should update stock_location" do
    patch stock_location_url(@stock_location), params: { stock_location: { location_barcode: @stock_location.location_barcode, open_shelf: @stock_location.open_shelf, shelf_size: @stock_location.shelf_size, stock_id: @stock_location.stock_id } }
    assert_redirected_to stock_location_url(@stock_location)
  end

  test "should destroy stock_location" do
    assert_difference("StockLocation.count", -1) do
      delete stock_location_url(@stock_location)
    end

    assert_redirected_to stock_locations_url
  end
end
