require "test_helper"

class AssetWorkTransactionTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    Current.account = accounts(:one)
    @event = events(:asset_work_in)
    @punch_asset = assets(:punch_one) # punch_clock
    @emp_one = employees(:one)
    @emp_asset = @emp_one.asset
    # @resource_params = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 15:10:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    @resource_params = { "punched_at"=>"2022-10-06T19:16:09.301Z", "state"=>"IN", "ip_addr"=>"10.4.3.170", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
  end

  test "the correct params being delivered" do 
    assert @resource_params == { "punched_at"=>"2022-10-06T19:16:09.301Z", "state"=>"IN", "ip_addr"=>"10.4.3.170", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    assert @event.name == "AWT"
  end

  test "create an IN punch" do
    awt = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, @resource_params )
    assert awt.eventable.punched_at == "Thu, 06 Oct 2022 19:16:09.301000000 UTC +00:00"
    assert awt.state == 'IN'
    assert awt.eventable.asset_workday_sum == @emp_asset.asset_workday_sums.last
  end
  
  test "create all punches for IN, BREAK, IN, BREAK, IN, OUT" do
    morning_in = { "punched_at"=>"2022-10-07 06:10:12", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    morning_break = { "punched_at"=>"2022-10-07 09:10:12", "state"=>"BREAK", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    morning_resume = { "punched_at"=>"2022-10-07 09:22:12", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    lunch_break = { "punched_at"=>"2022-10-07 12:05:12", "state"=>"BREAK", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    lunch_resume = { "punched_at"=>"2022-10-07 12:37:12", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    afternoon_out = { "punched_at"=>"2022-10-07 14:17:12", "state"=>"OUT", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }

    awt1 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_in)
    @emp_asset.reload
    assert @emp_asset.state == 'IN'
    awt2 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_break)
    @emp_asset.reload
    assert @emp_asset.state == 'BREAK'
    awt3 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_resume)
    @emp_asset.reload
    assert @emp_asset.state == 'IN'
    awt4 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, lunch_break)
    @emp_asset.reload
    assert @emp_asset.state == 'BREAK'
    awt5 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, lunch_resume)
    @emp_asset.reload
    assert @emp_asset.state == 'IN'
    awt6 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, afternoon_out)
    @emp_asset.reload
    assert @emp_asset.state == 'OUT'

    awd = @emp_asset.asset_workday_sums.last
    assert awd.work_date.to_s == DateTime.parse("2022-10-07 06:10:12").to_date.to_s             # "2022-09-29"
    assert awd.work_minutes == (6 * 60 + 43 + 40)  #     3 + 2.43 + 1.40
    assert awd.break_minutes == 44
    assert awd.ot1_minutes == 0
    assert awd.ot2_minutes == 0
    assert awd.sick_minutes == 0
    assert awd.free_minutes == 0

  end
  
  test "create all punches for IN, BREAK, IN, SICK" do
    morning_in = { "punched_at"=>"2022-09-29 06:10:12", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    morning_break = { "punched_at"=>"2022-09-29 09:10:12", "state"=>"BREAK", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    morning_resume = { "punched_at"=>"2022-09-29 09:22:12", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
    sick = { "punched_at"=>"2022-09-29 12:05:12", "state"=>"SICK", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }

    awt1 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_in)
    awt2 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_break)
    awt3 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_resume)
    awt4 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, sick)
    @emp_asset.reload
    assert @emp_asset.state == 'SICK'

    awd = @emp_asset.asset_workday_sums.last
    assert awd.work_date.to_s == DateTime.parse("2022-09-29 06:10:12").to_date.to_s             # "2022-09-29"
    assert awd.work_minutes == 343
    assert awd.break_minutes == 12
    assert awd.ot1_minutes == 0
    assert awd.ot2_minutes == 0
    assert awd.sick_minutes == 0
    assert awd.free_minutes == 0

  end
  
  # test "create all punches for IN, SICK yesterday, IN, BREAK, IN, OUT" do
  #   yesterday_morning_in = { "punched_at"=>"2022-09-28 06:10:00", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
  #   yesterday_morning_sick = { "punched_at"=>"2022-09-28 07:15:00", "state"=>"SICK", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
  #   morning_in = { "punched_at"=>"2022-09-29 06:00:52", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
  #   morning_break = { "punched_at"=>"2022-09-29 09:10:02", "state"=>"BREAK", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
  #   morning_resume = { "punched_at"=>"2022-09-29 09:22:56", "state"=>"IN", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }
  #   morning_out = { "punched_at"=>"2022-09-29 12:05:12", "state"=>"OUT", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_asset.id, "ip_addr"=>"10.4.3.170", "punched_pupils"=> {"pupil_2"=>"on", "pupil_6"=>"on"} }

  #   awt1 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_in)
  #   awt2 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_break)
  #   awt3 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_resume)
  #   awt4 = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, morning_out)
  #   @emp_asset.reload
  #   assert @emp_asset.state == 'OUT'

  #   awd = @emp_asset.asset_workday_sums.last
  #   assert awd.work_date.to_s == DateTime.parse("2022-09-29 06:10:12").to_date.to_s             # "2022-09-29"
  #   assert awd.work_minutes == 351
  #   assert awd.break_minutes == 12
  #   assert awd.ot1_minutes == 0
  #   assert awd.ot2_minutes == 0
  #   assert awd.sick_minutes == 0
  #   assert awd.free_minutes == 0

  # end


end
