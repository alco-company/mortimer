require "test_helper"

class CronTaskTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    @schedule = "*/15 0 4,15 * 1-5 /usr/bin/find"
  end

  test "every minute should always be now!" do 
    assert_equal true, CronTask::CronTask.now?("* * * * * any-command")
  end

  test "ten past midnight mon-fri!" do 
    dt = DateTime.parse "2040-12-04 00:10:00"
    assert_equal true, CronTask::CronTask.now?("10 0 * * 1,2,3,4,5 any-command",dt)
  end

  test "a particular DateTime should only be now in their timewindow!" do 
    dt = DateTime.parse "2040-12-04 0:45:00"
    assert_equal true, CronTask::CronTask.now?(@schedule,dt)
  end

  test "serve the correct next run!" do 
    dt = DateTime.parse "2040-12-04 0:15:00"
    run_at = DateTime.parse "2040-12-04 0:30:00"
    scope,only_later = 'any', true
    assert_equal run_at.to_f, CronTask::CronTask.next_run(@schedule,dt,0,scope, only_later)
    dt = DateTime.parse "2040-12-04 0:13:00"
    run_at = DateTime.parse "2040-12-04 0:15:00"
    scope,only_later = 'any', true
    assert_equal run_at.to_f, CronTask::CronTask.next_run(@schedule,dt,0,scope, only_later)
    dt = DateTime.parse "2022-12-03 11:55:00"
    run_at = DateTime.parse "2022-12-03 12:00:00"
    schedule,scope,only_later = '0 12 * * 2,3,4,5,6','any', true
    assert_equal run_at.to_f, CronTask::CronTask.next_run(schedule,dt,0,scope, only_later)
  end

  test "serve the correct run after the next run!" do 
    dt = DateTime.parse "2040-12-04 0:15:00"
    run_at = DateTime.parse "2040-12-04 0:45:00"
    assert_equal run_at.to_f, CronTask::CronTask.next_run(@schedule,dt,1)
  end

  test "a particular DateTime should not be now in their timewindow - if outside the timewindow!" do 
    dt = DateTime.parse "2022-12-01 16:43:00"
    assert_equal false, CronTask::CronTask.now?(@schedule,dt)
  end

end