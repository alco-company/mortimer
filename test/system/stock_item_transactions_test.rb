require "application_system_test_case"

class StockItemTransactionsTest < ApplicationSystemTestCase
  setup do
    @stock_item_transaction = stock_item_transactions(:one)
  end

  test "visiting the index" do
    visit stock_item_transactions_url
    assert_selector "h1", text: "Stock item transactions"
  end

  test "should create stock item transaction" do
    visit stock_item_transactions_url
    click_on "New stock item transaction"

    fill_in "Barcodes", with: @stock_item_transaction.barcodes
    fill_in "Quantity", with: @stock_item_transaction.quantity
    fill_in "Stock item", with: @stock_item_transaction.stock_item_id
    fill_in "Stock location", with: @stock_item_transaction.stock_location_id
    fill_in "Stocked product", with: @stock_item_transaction.stocked_product_id
    fill_in "Unit", with: @stock_item_transaction.unit
    click_on "Create Stock item transaction"

    assert_text "Stock item transaction was successfully created"
    click_on "Back"
  end

  test "should update Stock item transaction" do
    visit stock_item_transaction_url(@stock_item_transaction)
    click_on "Edit this stock item transaction", match: :first

    fill_in "Barcodes", with: @stock_item_transaction.barcodes
    fill_in "Quantity", with: @stock_item_transaction.quantity
    fill_in "Stock item", with: @stock_item_transaction.stock_item_id
    fill_in "Stock location", with: @stock_item_transaction.stock_location_id
    fill_in "Stocked product", with: @stock_item_transaction.stocked_product_id
    fill_in "Unit", with: @stock_item_transaction.unit
    click_on "Update Stock item transaction"

    assert_text "Stock item transaction was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock item transaction" do
    visit stock_item_transaction_url(@stock_item_transaction)
    click_on "Destroy this stock item transaction", match: :first

    assert_text "Stock item transaction was successfully destroyed"
  end
end
