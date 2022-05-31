require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, params: { task: { duration: @task.duration, full_day: @task.full_day, location: @task.location, planned_end_at: @task.planned_end_at, planned_start_at: @task.planned_start_at, purpose: @task.purpose, recurring_end_at: @task.recurring_end_at, recurring_ical: @task.recurring_ical } }
    end

    assert_redirected_to task_url(Task.last)
  end

  test "should show task" do
    get task_url(@task)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_url(@task)
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), params: { task: { duration: @task.duration, full_day: @task.full_day, location: @task.location, planned_end_at: @task.planned_end_at, planned_start_at: @task.planned_start_at, purpose: @task.purpose, recurring_end_at: @task.recurring_end_at, recurring_ical: @task.recurring_ical } }
    assert_redirected_to task_url(@task)
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end
end
