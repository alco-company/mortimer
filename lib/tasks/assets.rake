desc "Prepare background jobs every midnight (this rake gets called with 'rake prepare_background_jobs' @daily from app.json)"

task asset_workday_sums: [:environment] do 
  #

  PROCESSABLE_EMPLOYEE_STATES = ['OUT','SICK','FREE']

  # run the sums of asset_work_transactions
  # punched yesterday for employees in all accounts
  Account.all.each do |account|
    Current.account = account
    Asset.all.employees.where(state: PROCESSABLE_EMPLOYEE_STATES).each do |employee_asset|
      dt = DateTime.tomorrow
      employee_asset.calendar.punch_work_related_events dt.yesterday, employee_asset
      awds = employee_asset.asset_workday_sums.where(work_date: dt.yesterday).first
      if awds
        prev_awds = employee_asset.asset_workday_sums.where(work_date: dt.yesterday - 1.year).first
        awds.calculate_on_transactions( employee_asset, prev_awds)
      end
    end
  end
  
end