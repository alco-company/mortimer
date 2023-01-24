class AssetWorkdaySumLastYearJob < ApplicationJob
  queue_as :default

  PROCESSABLE_EMPLOYEE_STATES = ['OUT','SICK','FREE']

  def perform(*args)
    begin     

      #
      # process all employees - no matter what account
      # and move free_time_minutes from this year to last year
      #

      # run the sums of asset_work_transactions
      # punched yesterday for employees in all accounts
      Account.all.each do |account|
        Current.account = account
        Asset.all.employees.where(state: PROCESSABLE_EMPLOYEE_STATES).each do |employee_asset|
          dt = Date.yesterday
          dt_last_year = dt - 1.year
          AssetWorkdaySum.move_free_time employee_asset.asset_workday_sums.where(work_date: [dt,dt_last_year])
        end
      end

    rescue => exception
      say exception
    ensure      
      say "AssetWorkdaySums done"
    end
  end
end
