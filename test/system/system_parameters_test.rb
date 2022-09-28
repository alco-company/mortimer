require "application_system_test_case"

class SystemParametersTest < ApplicationSystemTestCase
  setup do
    @system_parameter = system_parameters(:one)
  end

  test "visiting the index" do
    visit system_parameters_url
    assert_selector "h1", text: "System parameters"
  end

  test "should create system parameter" do
    visit system_parameters_url
    click_on "New system parameter"

    fill_in "Account", with: @system_parameter.account_id
    fill_in "Deleted at", with: @system_parameter.deleted_at
    fill_in "Name", with: @system_parameter.name
    fill_in "Position", with: @system_parameter.position
    fill_in "System key", with: @system_parameter.system_key
    fill_in "Value", with: @system_parameter.value
    click_on "Create System parameter"

    assert_text "System parameter was successfully created"
    click_on "Back"
  end

  test "should update System parameter" do
    visit system_parameter_url(@system_parameter)
    click_on "Edit this system parameter", match: :first

    fill_in "Account", with: @system_parameter.account_id
    fill_in "Deleted at", with: @system_parameter.deleted_at
    fill_in "Name", with: @system_parameter.name
    fill_in "Position", with: @system_parameter.position
    fill_in "System key", with: @system_parameter.system_key
    fill_in "Value", with: @system_parameter.value
    click_on "Update System parameter"

    assert_text "System parameter was successfully updated"
    click_on "Back"
  end

  test "should destroy System parameter" do
    visit system_parameter_url(@system_parameter)
    click_on "Destroy this system parameter", match: :first

    assert_text "System parameter was successfully destroyed"
  end
end
