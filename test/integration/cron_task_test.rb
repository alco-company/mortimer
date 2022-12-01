require "test_helper"

class CronTaskTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    @schedule = "*/15 0 1,15 * 1-5 /usr/bin/find"
  end

  test "every minute should always be now!" do 
    assert CronTask::CronTask.now?("* * * * * any-command"), true
  end

  test "a particular DateTime should only be now in their timewindow!" do 
    dt = DateTime.parse "2022-12-01 0:45:00"
    assert_equal true, CronTask::CronTask.now?(@schedule,dt)
  end

  test "a particular DateTime should not be now in their timewindow - if outside the timewindow!" do 
    dt = DateTime.parse "2022-12-01 16:43:00"
    assert_equal false, CronTask::CronTask.now?(@schedule,dt)
  end

end