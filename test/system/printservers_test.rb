require "application_system_test_case"

class PrintserversTest < ApplicationSystemTestCase
  setup do
    @printserver = printservers(:one)
  end

  test "visiting the index" do
    visit printservers_url
    assert_selector "h1", text: "Printservers"
  end

  test "should create printserver" do
    visit printservers_url
    click_on "New printserver"

    fill_in "Asset", with: @printserver.asset_id
    fill_in "Mac addr", with: @printserver.mac_addr
    fill_in "Port", with: @printserver.port
    click_on "Create Printserver"

    assert_text "Printserver was successfully created"
    click_on "Back"
  end

  test "should update Printserver" do
    visit printserver_url(@printserver)
    click_on "Edit this printserver", match: :first

    fill_in "Asset", with: @printserver.asset_id
    fill_in "Mac addr", with: @printserver.mac_addr
    fill_in "Port", with: @printserver.port
    click_on "Update Printserver"

    assert_text "Printserver was successfully updated"
    click_on "Back"
  end

  test "should destroy Printserver" do
    visit printserver_url(@printserver)
    click_on "Destroy this printserver", match: :first

    assert_text "Printserver was successfully destroyed"
  end
end
