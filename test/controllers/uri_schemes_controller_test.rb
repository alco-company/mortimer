require "test_helper"

class UriSchemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @uri_scheme = uri_schemes(:one)
  end

  test "should get index" do
    get uri_schemes_url
    assert_response :success
  end

  test "should get new" do
    get new_uri_scheme_url
    assert_response :success
  end

  test "should create uri_scheme" do
    assert_difference("UriScheme.count") do
      post uri_schemes_url, params: { uri_scheme: { general_format: @uri_scheme.general_format, notes: @uri_scheme.notes, purpose: @uri_scheme.purpose, reference: @uri_scheme.reference, scheme: @uri_scheme.scheme, state: @uri_scheme.state } }
    end

    assert_redirected_to uri_scheme_url(UriScheme.last)
  end

  test "should show uri_scheme" do
    get uri_scheme_url(@uri_scheme)
    assert_response :success
  end

  test "should get edit" do
    get edit_uri_scheme_url(@uri_scheme)
    assert_response :success
  end

  test "should update uri_scheme" do
    patch uri_scheme_url(@uri_scheme), params: { uri_scheme: { general_format: @uri_scheme.general_format, notes: @uri_scheme.notes, purpose: @uri_scheme.purpose, reference: @uri_scheme.reference, scheme: @uri_scheme.scheme, state: @uri_scheme.state } }
    assert_redirected_to uri_scheme_url(@uri_scheme)
  end

  test "should destroy uri_scheme" do
    assert_difference("UriScheme.count", -1) do
      delete uri_scheme_url(@uri_scheme)
    end

    assert_redirected_to uri_schemes_url
  end
end
