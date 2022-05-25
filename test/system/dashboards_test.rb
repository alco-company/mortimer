require "application_system_test_case"

class DashboardsTest < ApplicationSystemTestCase
  setup do
    @dashboard = dashboards(:one)
  end

  test "no dashboard exist" do 
    visit "/"
    assert_text "Requested Dashboard Was Not Found"
    assert_text '"dashboard not found!"'
  end

  test "visiting the index" do
    visit dashboards_url
    assert_selector "h1", text: "Dashboards"
  end

  test "should create dashboard" do
    visit dashboards_url
    click_on "New dashboard"

    fill_in "Body", with: @dashboard.body
    fill_in "Layout", with: @dashboard.layout
    fill_in "Name", with: @dashboard.name
    click_on "Create Dashboard"

    assert_text "Dashboard was successfully created"
    click_on "Back"
  end

  test "should update Dashboard" do
    visit dashboard_url(@dashboard)
    click_on "Edit this dashboard", match: :first

    fill_in "Body", with: @dashboard.body
    fill_in "Layout", with: @dashboard.layout
    fill_in "Name", with: @dashboard.name
    click_on "Update Dashboard"

    assert_text "Dashboard was successfully updated"
    click_on "Back"
  end

  test "should destroy Dashboard" do
    visit dashboard_url(@dashboard)
    click_on "Destroy this dashboard", match: :first

    assert_text "Dashboard was successfully destroyed"
  end
end
