require "application_system_test_case"

class PupilTransactionsTest < ApplicationSystemTestCase
  setup do
    @pupil_transaction = pupil_transactions(:one)
  end

  test "visiting the index" do
    visit pupil_transactions_url
    assert_selector "h1", text: "Pupil transactions"
  end

  test "should create pupil transaction" do
    visit pupil_transactions_url
    click_on "New pupil transaction"

    fill_in "Asset", with: @pupil_transaction.asset_id
    fill_in "Pupil", with: @pupil_transaction.pupil_id
    fill_in "Work minutes", with: @pupil_transaction.work_minutes
    click_on "Create Pupil transaction"

    assert_text "Pupil transaction was successfully created"
    click_on "Back"
  end

  test "should update Pupil transaction" do
    visit pupil_transaction_url(@pupil_transaction)
    click_on "Edit this pupil transaction", match: :first

    fill_in "Asset", with: @pupil_transaction.asset_id
    fill_in "Pupil", with: @pupil_transaction.pupil_id
    fill_in "Work minutes", with: @pupil_transaction.work_minutes
    click_on "Update Pupil transaction"

    assert_text "Pupil transaction was successfully updated"
    click_on "Back"
  end

  test "should destroy Pupil transaction" do
    visit pupil_transaction_url(@pupil_transaction)
    click_on "Destroy this pupil transaction", match: :first

    assert_text "Pupil transaction was successfully destroyed"
  end
end
