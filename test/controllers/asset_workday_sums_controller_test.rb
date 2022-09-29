require "test_helper"

class AssetWorkdaySumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_workday_sum = asset_workday_sums(:one)
  end

  test "should get index" do
    get asset_workday_sums_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_workday_sum_url
    assert_response :success
  end

  test "should create asset_workday_sum" do
    assert_difference("AssetWorkdaySum.count") do
      post asset_workday_sums_url, params: { asset_workday_sum: { account_id: @asset_workday_sum.account_id, asset_id: @asset_workday_sum.asset_id, break_minutes: @asset_workday_sum.break_minutes, deleted_at: @asset_workday_sum.deleted_at, free_minutes: @asset_workday_sum.free_minutes, ot1_minutes: @asset_workday_sum.ot1_minutes, ot2_minutes: @asset_workday_sum.ot2_minutes, sick_minutes: @asset_workday_sum.sick_minutes, work_date: @asset_workday_sum.work_date, work_minutes: @asset_workday_sum.work_minutes } }
    end

    assert_redirected_to asset_workday_sum_url(AssetWorkdaySum.last)
  end

  test "should show asset_workday_sum" do
    get asset_workday_sum_url(@asset_workday_sum)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_workday_sum_url(@asset_workday_sum)
    assert_response :success
  end

  test "should update asset_workday_sum" do
    patch asset_workday_sum_url(@asset_workday_sum), params: { asset_workday_sum: { account_id: @asset_workday_sum.account_id, asset_id: @asset_workday_sum.asset_id, break_minutes: @asset_workday_sum.break_minutes, deleted_at: @asset_workday_sum.deleted_at, free_minutes: @asset_workday_sum.free_minutes, ot1_minutes: @asset_workday_sum.ot1_minutes, ot2_minutes: @asset_workday_sum.ot2_minutes, sick_minutes: @asset_workday_sum.sick_minutes, work_date: @asset_workday_sum.work_date, work_minutes: @asset_workday_sum.work_minutes } }
    assert_redirected_to asset_workday_sum_url(@asset_workday_sum)
  end

  test "should destroy asset_workday_sum" do
    assert_difference("AssetWorkdaySum.count", -1) do
      delete asset_workday_sum_url(@asset_workday_sum)
    end

    assert_redirected_to asset_workday_sums_url
  end
end
