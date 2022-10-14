require "test_helper"

class PupilTransactionTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  self.use_transactional_tests = true

  def setup 
    Current.account = accounts(:one)
    @event = events(:asset_work_in)
    @punch_asset = assets(:punch_one)
    @emp_one = employees(:one)
    @emp_asset = @emp_one.asset
    @pupil = pupils(:one)
    @pupil2 = pupils(:two)
    @emp_one.pupils << @pupil
    @emp_one.pupils << @pupil2
    @pupil_event_in = events(:pupil_work_in)
    @pupil_event_out = events(:pupil_work_out)
    # @resource_params = { "asset_work_transaction"=>{"punched_at"=>"2022-09-29 15:10:12", "state"=>"IN", "employee_id"=>"#{ @emp_one.id }", "punch_asset_id"=>"#{ @punch_asset.id }", "ip_addr"=>"10.4.3.170" }, "api_key"=>"[FILTERED]" }
    @resource_params = { "punched_at"=>"2022-10-06T19:16:09.301Z", "state"=>"IN", "ip_addr"=>"10.4.3.170", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_one.id, "punched_pupils"=> {"pupil_#{@pupil.id}"=>"on", "pupil_#{@pupil2.id}"=>"on"} }
  end

  test "verify that the correct params are available " do
    assert @resource_params == { "punched_at"=>"2022-10-06T19:16:09.301Z", "state"=>"IN", "ip_addr"=>"10.4.3.170", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_one.id, "punched_pupils"=> {"pupil_#{@pupil.id}"=>"on", "pupil_#{@pupil2.id}"=>"on"} }
    assert @resource_params["punched_pupils"]["pupil_#{@pupil.id}"] == "on"
  end

  test "punching IN with one pupil marked does add a pupil_transaction" do
    awt = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, @resource_params ) 
    pt = PupilTransactionService.new.create_pupil_transaction( @emp_asset, awt, @resource_params ) 
    assert pt.first.pupil_transactions.first.class == PupilTransaction
  end

  test "punching IN and OUT does add pupil_transaction" do
    r1 = { "punched_at"=>"2022-10-06T19:16:09.301Z", "state"=>"IN", "ip_addr"=>"10.4.3.170", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_one.id, "punched_pupils"=> {"pupil_#{@pupil.id}"=>"on", "pupil_#{@pupil2.id}"=>"on"} }
    r2 = { "punched_at"=>"2022-10-06T20:16:09.301Z", "state"=>"OUT", "ip_addr"=>"10.4.3.170", "punch_asset_id"=> @punch_asset.id, "employee_asset_id"=> @emp_one.id, "punched_pupils"=> {"pupil_#{@pupil.id}"=>"on", "pupil_#{@pupil2.id}"=>"on"} }
    awt = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, r1 ) 
    pt = PupilTransactionService.new.create_pupil_transaction( @emp_asset, awt, r1 ) 
 
    awt = AssetWorkTransactionService.new.create_employee_punch_transaction( @emp_asset, r2 ) 
    pt = PupilTransactionService.new.create_pupil_transaction( @emp_asset, awt, r2 ) 

    assert @emp_one.pupils.first.pupil_transactions.count == 2
    assert @emp_one.pupils.first.pupil_transactions.last.work_minutes == 60
  end
  

end
