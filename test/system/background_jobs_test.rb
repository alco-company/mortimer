require "application_system_test_case"

class BackgroundJobsTest < ApplicationSystemTestCase
  setup do
    @background_job = background_jobs(:one)
  end

  test "visiting the index" do
    visit background_jobs_url
    assert_selector "h1", text: "Background jobs"
  end

  test "should create background job" do
    visit background_jobs_url
    click_on "New background job"

    fill_in "Execute at", with: @background_job.execute_at
    fill_in "Job", with: @background_job.job_id
    fill_in "Params", with: @background_job.params
    fill_in "Work", with: @background_job.work
    click_on "Create Background job"

    assert_text "Background job was successfully created"
    click_on "Back"
  end

  test "should update Background job" do
    visit background_job_url(@background_job)
    click_on "Edit this background job", match: :first

    fill_in "Execute at", with: @background_job.execute_at
    fill_in "Job", with: @background_job.job_id
    fill_in "Params", with: @background_job.params
    fill_in "Work", with: @background_job.work
    click_on "Update Background job"

    assert_text "Background job was successfully updated"
    click_on "Back"
  end

  test "should destroy Background job" do
    visit background_job_url(@background_job)
    click_on "Destroy this background job", match: :first

    assert_text "Background job was successfully destroyed"
  end
end
