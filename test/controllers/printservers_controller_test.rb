require "test_helper"

class PrintserversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @printserver = printservers(:one)
  end

  test "should get index" do
    get printservers_url
    assert_response :success
  end

  test "should get new" do
    get new_printserver_url
    assert_response :success
  end

  test "should create printserver" do
    assert_difference("Printserver.count") do
      post printservers_url, params: { printserver: { asset_id: @printserver.asset_id, mac_addr: @printserver.mac_addr, port: @printserver.port } }
    end

    assert_redirected_to printserver_url(Printserver.last)
  end

  test "should show printserver" do
    get printserver_url(@printserver)
    assert_response :success
  end

  test "should get edit" do
    get edit_printserver_url(@printserver)
    assert_response :success
  end

  test "should update printserver" do
    patch printserver_url(@printserver), params: { printserver: { asset_id: @printserver.asset_id, mac_addr: @printserver.mac_addr, port: @printserver.port } }
    assert_redirected_to printserver_url(@printserver)
  end

  test "should destroy printserver" do
    assert_difference("Printserver.count", -1) do
      delete printserver_url(@printserver)
    end

    assert_redirected_to printservers_url
  end
end
