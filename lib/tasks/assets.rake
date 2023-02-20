desc "Prepare background jobs every midnight (this rake gets called with 'rake prepare_background_jobs' @daily from app.json)"

task asset_workday_sums: [:environment] do 
  #

  # PROCESSABLE_EMPLOYEE_STATES = ['OUT','SICK','FREE','BREAK']

  # run the sums of asset_work_transactions
  # punched yesterday for employees in all accounts
  Account.all.each do |account|
    Current.account = account
    Asset.all.employees.each do |resource|
      srv = account.system_parameters_include("calc_asset_workday_sum") || "AssetWorkdaySumService"
      service = srv.classify.constantize.new
      day_range = DateTime.new(2023,1,1)..DateTime.new(2023,2,20)
      resource.asset_workday_sums.where(work_date: day_range).each do |awd|
        # puts "#{resource.name}: #{awd.work_date}"
        service.update_workday_sum( resource, awd.asset_work_transactions.first.event )
      end

      # dt = DateTime.tomorrow
      # employee_asset.calendar.punch_work_related_events dt.yesterday, employee_asset
      # awds = employee_asset.asset_workday_sums.where(work_date: dt.yesterday).first
      # if awds
      #   prev_awds = employee_asset.asset_workday_sums.where(work_date: dt.yesterday - 1.year).first
      #   awds.calculate_on_transactions( employee_asset, prev_awds)
      # end
    end
  end
  
end