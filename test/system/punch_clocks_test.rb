require "application_system_test_case"

class PunchClocksTest < ApplicationSystemTestCase
  setup do
    @punch_clock = punch_clocks(:one)
  end

  test "visiting the index" do
    visit punch_clocks_url
    assert_selector "h1", text: "Punch clocks"
  end

  test "should create punch clock" do
    visit punch_clocks_url
    click_on "New punch clock"

    fill_in "Deleted at", with: @punch_clock.deleted_at
    fill_in "Ip addr", with: @punch_clock.ip_addr
    fill_in "Last punch at", with: @punch_clock.last_punch_at
    fill_in "Location", with: @punch_clock.location
    click_on "Create Punch clock"

    assert_text "Punch clock was successfully created"
    click_on "Back"
  end

  test "should update Punch clock" do
    visit punch_clock_url(@punch_clock)
    click_on "Edit this punch clock", match: :first

    fill_in "Deleted at", with: @punch_clock.deleted_at
    fill_in "Ip addr", with: @punch_clock.ip_addr
    fill_in "Last punch at", with: @punch_clock.last_punch_at
    fill_in "Location", with: @punch_clock.location
    click_on "Update Punch clock"

    assert_text "Punch clock was successfully updated"
    click_on "Back"
  end

  test "should destroy Punch clock" do
    visit punch_clock_url(@punch_clock)
    click_on "Destroy this punch clock", match: :first

    assert_text "Punch clock was successfully destroyed"
  end
end
