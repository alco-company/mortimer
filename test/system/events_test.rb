require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Account", with: @event.account_id
    fill_in "Ancestry", with: @event.ancestry
    fill_in "Calendar", with: @event.calendar_id
    fill_in "Deleted at", with: @event.deleted_at
    fill_in "Ended at", with: @event.ended_at
    fill_in "Eventable", with: @event.eventable_id
    fill_in "Eventable type", with: @event.eventable_type
    fill_in "Minutes spent", with: @event.minutes_spent
    fill_in "Name", with: @event.name
    fill_in "Position", with: @event.position
    fill_in "Started at", with: @event.started_at
    fill_in "State", with: @event.state
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Account", with: @event.account_id
    fill_in "Ancestry", with: @event.ancestry
    fill_in "Calendar", with: @event.calendar_id
    fill_in "Deleted at", with: @event.deleted_at
    fill_in "Ended at", with: @event.ended_at
    fill_in "Eventable", with: @event.eventable_id
    fill_in "Eventable type", with: @event.eventable_type
    fill_in "Minutes spent", with: @event.minutes_spent
    fill_in "Name", with: @event.name
    fill_in "Position", with: @event.position
    fill_in "Started at", with: @event.started_at
    fill_in "State", with: @event.state
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
