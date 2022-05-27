require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "New user"

    fill_in "Account", with: @user.account_id
    fill_in "Confirmed at", with: @user.confirmed_at
    fill_in "Email", with: @user.email
    fill_in "Logged in at", with: @user.logged_in_at
    fill_in "On task since at", with: @user.on_task_since_at
    fill_in "Password digest", with: @user.password_digest
    fill_in "Remember token", with: @user.remember_token
    fill_in "Session token", with: @user.session_token
    fill_in "Unconfirmed email", with: @user.unconfirmed_email
    fill_in "User name", with: @user.user_name
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    fill_in "Account", with: @user.account_id
    fill_in "Confirmed at", with: @user.confirmed_at
    fill_in "Email", with: @user.email
    fill_in "Logged in at", with: @user.logged_in_at
    fill_in "On task since at", with: @user.on_task_since_at
    fill_in "Password digest", with: @user.password_digest
    fill_in "Remember token", with: @user.remember_token
    fill_in "Session token", with: @user.session_token
    fill_in "Unconfirmed email", with: @user.unconfirmed_email
    fill_in "User name", with: @user.user_name
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "should destroy User" do
    visit user_url(@user)
    click_on "Destroy this user", match: :first

    assert_text "User was successfully destroyed"
  end
end
