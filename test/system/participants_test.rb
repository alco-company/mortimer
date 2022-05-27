require "application_system_test_case"

class ParticipantsTest < ApplicationSystemTestCase
  setup do
    @participant = participants(:one)
  end

  test "visiting the index" do
    visit participants_url
    assert_selector "h1", text: "Participants"
  end

  test "should create participant" do
    visit participants_url
    click_on "New participant"

    fill_in "Account", with: @participant.account_id
    fill_in "Ancestry", with: @participant.ancestry
    fill_in "Calendar", with: @participant.calendar_id
    fill_in "Deleted at", with: @participant.deleted_at
    fill_in "Name", with: @participant.name
    fill_in "Participantable", with: @participant.participantable_id
    fill_in "Participantable type", with: @participant.participantable_type
    fill_in "State", with: @participant.state
    click_on "Create Participant"

    assert_text "Participant was successfully created"
    click_on "Back"
  end

  test "should update Participant" do
    visit participant_url(@participant)
    click_on "Edit this participant", match: :first

    fill_in "Account", with: @participant.account_id
    fill_in "Ancestry", with: @participant.ancestry
    fill_in "Calendar", with: @participant.calendar_id
    fill_in "Deleted at", with: @participant.deleted_at
    fill_in "Name", with: @participant.name
    fill_in "Participantable", with: @participant.participantable_id
    fill_in "Participantable type", with: @participant.participantable_type
    fill_in "State", with: @participant.state
    click_on "Update Participant"

    assert_text "Participant was successfully updated"
    click_on "Back"
  end

  test "should destroy Participant" do
    visit participant_url(@participant)
    click_on "Destroy this participant", match: :first

    assert_text "Participant was successfully destroyed"
  end
end
