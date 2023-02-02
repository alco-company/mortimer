require "application_system_test_case"

class UriSchemesTest < ApplicationSystemTestCase
  setup do
    @uri_scheme = uri_schemes(:one)
  end

  test "visiting the index" do
    visit uri_schemes_url
    assert_selector "h1", text: "Uri schemes"
  end

  test "should create uri scheme" do
    visit uri_schemes_url
    click_on "New uri scheme"

    fill_in "General format", with: @uri_scheme.general_format
    fill_in "Notes", with: @uri_scheme.notes
    fill_in "Purpose", with: @uri_scheme.purpose
    fill_in "Reference", with: @uri_scheme.reference
    fill_in "Scheme", with: @uri_scheme.scheme
    fill_in "State", with: @uri_scheme.state
    click_on "Create Uri scheme"

    assert_text "Uri scheme was successfully created"
    click_on "Back"
  end

  test "should update Uri scheme" do
    visit uri_scheme_url(@uri_scheme)
    click_on "Edit this uri scheme", match: :first

    fill_in "General format", with: @uri_scheme.general_format
    fill_in "Notes", with: @uri_scheme.notes
    fill_in "Purpose", with: @uri_scheme.purpose
    fill_in "Reference", with: @uri_scheme.reference
    fill_in "Scheme", with: @uri_scheme.scheme
    fill_in "State", with: @uri_scheme.state
    click_on "Update Uri scheme"

    assert_text "Uri scheme was successfully updated"
    click_on "Back"
  end

  test "should destroy Uri scheme" do
    visit uri_scheme_url(@uri_scheme)
    click_on "Destroy this uri scheme", match: :first

    assert_text "Uri scheme was successfully destroyed"
  end
end
