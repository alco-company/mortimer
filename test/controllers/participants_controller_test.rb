require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @participant = participants(:one)
  end

  test "should get index" do
    get participants_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_url
    assert_response :success
  end

  test "should create participant" do
    assert_difference("Participant.count") do
      post participants_url, params: { participant: { account_id: @participant.account_id, ancestry: @participant.ancestry, calendar_id: @participant.calendar_id, deleted_at: @participant.deleted_at, name: @participant.name, participantable_id: @participant.participantable_id, participantable_type: @participant.participantable_type, state: @participant.state } }
    end

    assert_redirected_to participant_url(Participant.last)
  end

  test "should show participant" do
    get participant_url(@participant)
    assert_response :success
  end

  test "should get edit" do
    get edit_participant_url(@participant)
    assert_response :success
  end

  test "should update participant" do
    patch participant_url(@participant), params: { participant: { account_id: @participant.account_id, ancestry: @participant.ancestry, calendar_id: @participant.calendar_id, deleted_at: @participant.deleted_at, name: @participant.name, participantable_id: @participant.participantable_id, participantable_type: @participant.participantable_type, state: @participant.state } }
    assert_redirected_to participant_url(@participant)
  end

  test "should destroy participant" do
    assert_difference("Participant.count", -1) do
      delete participant_url(@participant)
    end

    assert_redirected_to participants_url
  end
end
