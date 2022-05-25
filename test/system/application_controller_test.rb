require "application_system_test_case"

class ApplicationControllerTest < ApplicationSystemTestCase
  setup do
    @dashboard = dashboards(:one)
  end

  test "should get danish locale" do
    visit dashboards_url
    assert_text 'Ny'
  end

end
