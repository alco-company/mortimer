require "test_helper"

class AssetWorkTransactionTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    Current.account = accounts(:one)
    @event = events(:asset_work_in)
    @punch_asset = assets(:punch_one)
    @emp_one = employees(:one)
    @resource_params = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 15:10:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
  end

  test "the correct params being delivered" do 
    assert @resource_params == { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 15:10:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170"}, "api_key"=>"[FILTERED]" }
    @awt = asset_work_transactions(:in)
    assert @event.name == "AWT"
    assert @awt.punch_asset_ip_addr == "10.4.3.170"
    assert @awt.asset.name == "John Doe"
  end

  test "create an IN punch" do
    awt = AssetWorkTransactionService.new.create_employee_punch_transaction(@resource_params)
    assert awt.eventable.punched_at == "2022-09-29 15:10:12"
  end
  
  test "create all punches for IN, BREAK, IN, BREAK, IN, OUT" do
    morning_in = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 06:10:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_break = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 09:10:12", "state"=>"BREAK", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_resume = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 09:22:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    lunch_break = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 12:05:12", "state"=>"BREAK", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    lunch_resume = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 12:37:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    afternoon_out = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 14:17:12", "state"=>"OUT", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }

    awt1 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_in)
    @emp_one.reload
    assert @emp_one.state == 'IN'
    awt2 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_break)
    @emp_one.reload
    assert @emp_one.state == 'BREAK'
    awt3 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_resume)
    @emp_one.reload
    assert @emp_one.state == 'IN'
    awt4 = AssetWorkTransactionService.new.create_employee_punch_transaction(lunch_break)
    @emp_one.reload
    assert @emp_one.state == 'BREAK'
    awt5 = AssetWorkTransactionService.new.create_employee_punch_transaction(lunch_resume)
    @emp_one.reload
    assert @emp_one.state == 'IN'
    awt6 = AssetWorkTransactionService.new.create_employee_punch_transaction(afternoon_out)
    @emp_one.reload
    assert @emp_one.state == 'OUT'

    awd = @emp_one.asset_workday_sums.last
    assert awd.work_date.to_s == DateTime.parse("2022-09-29 06:10:12").to_date.to_s             # "2022-09-29"
    assert awd.work_minutes == (6 * 60 + 43 + 40)  #     3 + 2.43 + 1.40
    assert awd.break_minutes == 44
    assert awd.ot1_minutes == 0
    assert awd.ot2_minutes == 0
    assert awd.sick_minutes == 0
    assert awd.free_minutes == 0

  end
  
  test "create all punches for IN, BREAK, IN, SICK" do
    morning_in = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 06:10:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_break = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 09:10:12", "state"=>"BREAK", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_resume = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 09:22:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    sick = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 12:05:12", "state"=>"SICK", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }

    awt1 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_in)
    awt2 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_break)
    awt3 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_resume)
    awt4 = AssetWorkTransactionService.new.create_employee_punch_transaction(sick)
    @emp_one.reload
    assert @emp_one.state == 'SICK'

    awd = @emp_one.asset_workday_sums.last
    assert awd.work_date.to_s == DateTime.parse("2022-09-29 06:10:12").to_date.to_s             # "2022-09-29"
    assert awd.work_minutes == 343
    assert awd.break_minutes == 12
    assert awd.ot1_minutes == 0
    assert awd.ot2_minutes == 0
    assert awd.sick_minutes == 0
    assert awd.free_minutes == 0

  end
  
  test "create all punches for IN, SICK yesterday, IN, BREAK, IN, OUT" do
    yesterday_morning_in = { "asset_work_transaction"=>{"punched_at"=>"2022-09-28 06:10:00", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    yesterday_morning_sick = { "asset_work_transaction"=>{"punched_at"=>"2022-09-28 07:15:00", "state"=>"SICK", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_in = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 06:00:52", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_break = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 09:10:02", "state"=>"BREAK", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    morning_resume = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 09:22:56", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    sick = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 12:05:12", "state"=>"OUT", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }

    awt1 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_in)
    awt2 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_break)
    awt3 = AssetWorkTransactionService.new.create_employee_punch_transaction(morning_resume)
    awt4 = AssetWorkTransactionService.new.create_employee_punch_transaction(sick)
    @emp_one.reload
    assert @emp_one.state == 'SICK'

    awd = @emp_one.asset_workday_sums.last
    assert awd.work_date.to_s == DateTime.parse("2022-09-29 06:10:12").to_date.to_s             # "2022-09-29"
    assert awd.work_minutes == 343
    assert awd.break_minutes == 12
    assert awd.ot1_minutes == 0
    assert awd.ot2_minutes == 0
    assert awd.sick_minutes == 0
    assert awd.free_minutes == 0

  end


end
