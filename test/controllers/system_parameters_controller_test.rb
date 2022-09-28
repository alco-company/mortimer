require "test_helper"

class SystemParametersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_parameter = system_parameters(:one)
  end

  test "should get index" do
    get system_parameters_url
    assert_response :success
  end

  test "should get new" do
    get new_system_parameter_url
    assert_response :success
  end

  test "should create system_parameter" do
    assert_difference("SystemParameter.count") do
      post system_parameters_url, params: { system_parameter: { account_id: @system_parameter.account_id, deleted_at: @system_parameter.deleted_at, name: @system_parameter.name, position: @system_parameter.position, system_key: @system_parameter.system_key, value: @system_parameter.value } }
    end

    assert_redirected_to system_parameter_url(SystemParameter.last)
  end

  test "should show system_parameter" do
    get system_parameter_url(@system_parameter)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_parameter_url(@system_parameter)
    assert_response :success
  end

  test "should update system_parameter" do
    patch system_parameter_url(@system_parameter), params: { system_parameter: { account_id: @system_parameter.account_id, deleted_at: @system_parameter.deleted_at, name: @system_parameter.name, position: @system_parameter.position, system_key: @system_parameter.system_key, value: @system_parameter.value } }
    assert_redirected_to system_parameter_url(@system_parameter)
  end

  test "should destroy system_parameter" do
    assert_difference("SystemParameter.count", -1) do
      delete system_parameter_url(@system_parameter)
    end

    assert_redirected_to system_parameters_url
  end
end
