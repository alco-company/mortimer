require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @profile = profiles(:one)
    Current.account = accounts(:one)
    puts @user.to_json
    puts @profile.to_json
    # @user.profile.time_zone = "Europe/Berlin"
  end

  test "should have a valid time zone" do
    @profile.time_zone = "invalid time zone"
    assert_not @profile.valid?
  end
end
