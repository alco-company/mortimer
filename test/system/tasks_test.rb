require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @task = tasks(:one)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
  end

  test "should create task" do
    visit tasks_url
    click_on "New task"

    fill_in "Duration", with: @task.duration
    check "Full day" if @task.full_day
    fill_in "Location", with: @task.location
    fill_in "Planned end at", with: @task.planned_end_at
    fill_in "Planned start at", with: @task.planned_start_at
    fill_in "Purpose", with: @task.purpose
    fill_in "Recurring end at", with: @task.recurring_end_at
    fill_in "Recurring ical", with: @task.recurring_ical
    click_on "Create Task"

    assert_text "Task was successfully created"
    click_on "Back"
  end

  test "should update Task" do
    visit task_url(@task)
    click_on "Edit this task", match: :first

    fill_in "Duration", with: @task.duration
    check "Full day" if @task.full_day
    fill_in "Location", with: @task.location
    fill_in "Planned end at", with: @task.planned_end_at
    fill_in "Planned start at", with: @task.planned_start_at
    fill_in "Purpose", with: @task.purpose
    fill_in "Recurring end at", with: @task.recurring_end_at
    fill_in "Recurring ical", with: @task.recurring_ical
    click_on "Update Task"

    assert_text "Task was successfully updated"
    click_on "Back"
  end

  test "should destroy Task" do
    visit task_url(@task)
    click_on "Destroy this task", match: :first

    assert_text "Task was successfully destroyed"
  end
end
