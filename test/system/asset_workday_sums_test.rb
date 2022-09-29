require "application_system_test_case"

class AssetWorkdaySumsTest < ApplicationSystemTestCase
  setup do
    @asset_workday_sum = asset_workday_sums(:one)
  end

  test "visiting the index" do
    visit asset_workday_sums_url
    assert_selector "h1", text: "Asset workday sums"
  end

  test "should create asset workday sum" do
    visit asset_workday_sums_url
    click_on "New asset workday sum"

    fill_in "Account", with: @asset_workday_sum.account_id
    fill_in "Asset", with: @asset_workday_sum.asset_id
    fill_in "Break minutes", with: @asset_workday_sum.break_minutes
    fill_in "Deleted at", with: @asset_workday_sum.deleted_at
    fill_in "Free minutes", with: @asset_workday_sum.free_minutes
    fill_in "Ot1 minutes", with: @asset_workday_sum.ot1_minutes
    fill_in "Ot2 minutes", with: @asset_workday_sum.ot2_minutes
    fill_in "Sick minutes", with: @asset_workday_sum.sick_minutes
    fill_in "Work date", with: @asset_workday_sum.work_date
    fill_in "Work minutes", with: @asset_workday_sum.work_minutes
    click_on "Create Asset workday sum"

    assert_text "Asset workday sum was successfully created"
    click_on "Back"
  end

  test "should update Asset workday sum" do
    visit asset_workday_sum_url(@asset_workday_sum)
    click_on "Edit this asset workday sum", match: :first

    fill_in "Account", with: @asset_workday_sum.account_id
    fill_in "Asset", with: @asset_workday_sum.asset_id
    fill_in "Break minutes", with: @asset_workday_sum.break_minutes
    fill_in "Deleted at", with: @asset_workday_sum.deleted_at
    fill_in "Free minutes", with: @asset_workday_sum.free_minutes
    fill_in "Ot1 minutes", with: @asset_workday_sum.ot1_minutes
    fill_in "Ot2 minutes", with: @asset_workday_sum.ot2_minutes
    fill_in "Sick minutes", with: @asset_workday_sum.sick_minutes
    fill_in "Work date", with: @asset_workday_sum.work_date
    fill_in "Work minutes", with: @asset_workday_sum.work_minutes
    click_on "Update Asset workday sum"

    assert_text "Asset workday sum was successfully updated"
    click_on "Back"
  end

  test "should destroy Asset workday sum" do
    visit asset_workday_sum_url(@asset_workday_sum)
    click_on "Destroy this asset workday sum", match: :first

    assert_text "Asset workday sum was successfully destroyed"
  end
end
