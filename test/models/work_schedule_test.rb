require "test_helper"

class WorkScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup 
    @asset = Asset.create! account: accounts(:one), name: 'Stock', assetable: Stock.create 
    # @asset = Asset.create account: accounts(:one), name: "Stock 1", assetable: stocks(:one)
    @params = { "work_schedule"=>{"name"=>"", "started_at"=>"", "ended_at"=>"", "state"=>"", "roll"=>"", "position"=>"1", "calendar"=>""} }
  end



  test "that work_schedule records gets created" do
    ws1 = WorkScheduleService.new.create_work_schedule @params 
  end

end
