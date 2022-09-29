require "test_helper"

class PunchClocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @punch_clock = punch_clocks(:one)
  end

  test "should get index" do
    get punch_clocks_url
    assert_response :success
  end

  test "should get new" do
    get new_punch_clock_url
    assert_response :success
  end

  test "should create punch_clock" do
    assert_difference("PunchClock.count") do
      post punch_clocks_url, params: { punch_clock: { deleted_at: @punch_clock.deleted_at, ip_addr: @punch_clock.ip_addr, last_punch_at: @punch_clock.last_punch_at, location: @punch_clock.location } }
    end

    assert_redirected_to punch_clock_url(PunchClock.last)
  end

  test "should show punch_clock" do
    get punch_clock_url(@punch_clock)
    assert_response :success
  end

  test "should get edit" do
    get edit_punch_clock_url(@punch_clock)
    assert_response :success
  end

  test "should update punch_clock" do
    patch punch_clock_url(@punch_clock), params: { punch_clock: { deleted_at: @punch_clock.deleted_at, ip_addr: @punch_clock.ip_addr, last_punch_at: @punch_clock.last_punch_at, location: @punch_clock.location } }
    assert_redirected_to punch_clock_url(@punch_clock)
  end

  test "should destroy punch_clock" do
    assert_difference("PunchClock.count", -1) do
      delete punch_clock_url(@punch_clock)
    end

    assert_redirected_to punch_clocks_url
  end
end
