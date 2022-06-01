require "test_helper"

class StockedProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stocked_product = stocked_products(:one)
  end

  test "should get index" do
    get stocked_products_url
    assert_response :success
  end

  test "should get new" do
    get new_stocked_product_url
    assert_response :success
  end

  test "should create stocked_product" do
    assert_difference("StockedProduct.count") do
      post stocked_products_url, params: { stocked_product: { product_id: @stocked_product.product_id, quantity: @stocked_product.quantity, stock_id: @stocked_product.stock_id, stock_location_id: @stocked_product.stock_location_id, stock_unit: @stocked_product.stock_unit } }
    end

    assert_redirected_to stocked_product_url(StockedProduct.last)
  end

  test "should show stocked_product" do
    get stocked_product_url(@stocked_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_stocked_product_url(@stocked_product)
    assert_response :success
  end

  test "should update stocked_product" do
    patch stocked_product_url(@stocked_product), params: { stocked_product: { product_id: @stocked_product.product_id, quantity: @stocked_product.quantity, stock_id: @stocked_product.stock_id, stock_location_id: @stocked_product.stock_location_id, stock_unit: @stocked_product.stock_unit } }
    assert_redirected_to stocked_product_url(@stocked_product)
  end

  test "should destroy stocked_product" do
    assert_difference("StockedProduct.count", -1) do
      delete stocked_product_url(@stocked_product)
    end

    assert_redirected_to stocked_products_url
  end
end
