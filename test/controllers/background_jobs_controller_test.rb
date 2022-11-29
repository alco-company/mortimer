require "test_helper"

class BackgroundJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @background_job = background_jobs(:one)
  end

  test "should get index" do
    get background_jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_background_job_url
    assert_response :success
  end

  test "should create background_job" do
    assert_difference("BackgroundJob.count") do
      post background_jobs_url, params: { background_job: { execute_at: @background_job.execute_at, job_id: @background_job.job_id, params: @background_job.params, work: @background_job.work } }
    end

    assert_redirected_to background_job_url(BackgroundJob.last)
  end

  test "should show background_job" do
    get background_job_url(@background_job)
    assert_response :success
  end

  test "should get edit" do
    get edit_background_job_url(@background_job)
    assert_response :success
  end

  test "should update background_job" do
    patch background_job_url(@background_job), params: { background_job: { execute_at: @background_job.execute_at, job_id: @background_job.job_id, params: @background_job.params, work: @background_job.work } }
    assert_redirected_to background_job_url(@background_job)
  end

  test "should destroy background_job" do
    assert_difference("BackgroundJob.count", -1) do
      delete background_job_url(@background_job)
    end

    assert_redirected_to background_jobs_url
  end
end
