require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: { event: { account_id: @event.account_id, ancestry: @event.ancestry, calendar_id: @event.calendar_id, deleted_at: @event.deleted_at, ended_at: @event.ended_at, eventable_id: @event.eventable_id, eventable_type: @event.eventable_type, minutes_spent: @event.minutes_spent, name: @event.name, position: @event.position, started_at: @event.started_at, state: @event.state } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { account_id: @event.account_id, ancestry: @event.ancestry, calendar_id: @event.calendar_id, deleted_at: @event.deleted_at, ended_at: @event.ended_at, eventable_id: @event.eventable_id, eventable_type: @event.eventable_type, minutes_spent: @event.minutes_spent, name: @event.name, position: @event.position, started_at: @event.started_at, state: @event.state } }
    assert_redirected_to event_url(@event)
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
