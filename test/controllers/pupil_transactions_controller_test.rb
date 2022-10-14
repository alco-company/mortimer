require "test_helper"

class PupilTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pupil_transaction = pupil_transactions(:one)
  end

  test "should get index" do
    get pupil_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_pupil_transaction_url
    assert_response :success
  end

  test "should create pupil_transaction" do
    assert_difference("PupilTransaction.count") do
      post pupil_transactions_url, params: { pupil_transaction: { asset_id: @pupil_transaction.asset_id, pupil_id: @pupil_transaction.pupil_id, work_minutes: @pupil_transaction.work_minutes } }
    end

    assert_redirected_to pupil_transaction_url(PupilTransaction.last)
  end

  test "should show pupil_transaction" do
    get pupil_transaction_url(@pupil_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_pupil_transaction_url(@pupil_transaction)
    assert_response :success
  end

  test "should update pupil_transaction" do
    patch pupil_transaction_url(@pupil_transaction), params: { pupil_transaction: { asset_id: @pupil_transaction.asset_id, pupil_id: @pupil_transaction.pupil_id, work_minutes: @pupil_transaction.work_minutes } }
    assert_redirected_to pupil_transaction_url(@pupil_transaction)
  end

  test "should destroy pupil_transaction" do
    assert_difference("PupilTransaction.count", -1) do
      delete pupil_transaction_url(@pupil_transaction)
    end

    assert_redirected_to pupil_transactions_url
  end
end
