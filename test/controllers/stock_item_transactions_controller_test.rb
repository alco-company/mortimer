require "test_helper"

class StockItemTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_item_transaction = stock_item_transactions(:one)
  end

  test "should get index" do
    get stock_item_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_item_transaction_url
    assert_response :success
  end

  test "should create stock_item_transaction" do
    assert_difference("StockItemTransaction.count") do
      post stock_item_transactions_url, params: { stock_item_transaction: { barcodes: @stock_item_transaction.barcodes, quantity: @stock_item_transaction.quantity, stock_item_id: @stock_item_transaction.stock_item_id, stock_location_id: @stock_item_transaction.stock_location_id, stocked_product_id: @stock_item_transaction.stocked_product_id, unit: @stock_item_transaction.unit } }
    end

    assert_redirected_to stock_item_transaction_url(StockItemTransaction.last)
  end

  test "should show stock_item_transaction" do
    get stock_item_transaction_url(@stock_item_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_item_transaction_url(@stock_item_transaction)
    assert_response :success
  end

  test "should update stock_item_transaction" do
    patch stock_item_transaction_url(@stock_item_transaction), params: { stock_item_transaction: { barcodes: @stock_item_transaction.barcodes, quantity: @stock_item_transaction.quantity, stock_item_id: @stock_item_transaction.stock_item_id, stock_location_id: @stock_item_transaction.stock_location_id, stocked_product_id: @stock_item_transaction.stocked_product_id, unit: @stock_item_transaction.unit } }
    assert_redirected_to stock_item_transaction_url(@stock_item_transaction)
  end

  test "should destroy stock_item_transaction" do
    assert_difference("StockItemTransaction.count", -1) do
      delete stock_item_transaction_url(@stock_item_transaction)
    end

    assert_redirected_to stock_item_transactions_url
  end
end
