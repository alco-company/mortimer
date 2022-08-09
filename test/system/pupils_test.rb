require "application_system_test_case"

class PupilsTest < ApplicationSystemTestCase
  setup do
    @pupil = pupils(:one)
  end

  test "visiting the index" do
    visit pupils_url
    assert_selector "h1", text: "Pupils"
  end

  test "should create pupil" do
    visit pupils_url
    click_on "New pupil"

    fill_in "Account", with: @pupil.account_id
    fill_in "Deleted at", with: @pupil.deleted_at
    fill_in "Location", with: @pupil.location
    fill_in "State", with: @pupil.state
    fill_in "Time spent minutes", with: @pupil.time_spent_minutes
    click_on "Create Pupil"

    assert_text "Pupil was successfully created"
    click_on "Back"
  end

  test "should update Pupil" do
    visit pupil_url(@pupil)
    click_on "Edit this pupil", match: :first

    fill_in "Account", with: @pupil.account_id
    fill_in "Deleted at", with: @pupil.deleted_at
    fill_in "Location", with: @pupil.location
    fill_in "State", with: @pupil.state
    fill_in "Time spent minutes", with: @pupil.time_spent_minutes
    click_on "Update Pupil"

    assert_text "Pupil was successfully updated"
    click_on "Back"
  end

  test "should destroy Pupil" do
    visit pupil_url(@pupil)
    click_on "Destroy this pupil", match: :first

    assert_text "Pupil was successfully destroyed"
  end
end
