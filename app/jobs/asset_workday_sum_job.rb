class AssetWorkdaySumJob < ApplicationJob
  queue_as :default

  PROCESSABLE_EMPLOYEE_STATES = ['OUT','SICK','FREE']

  def perform(*args)
    begin     
      say "Running AssetWorkdaySums for yesterday against Calendars and AssetWorkTransactions"

      #
      # process all employees - no matter what account
      # and either add an asset_workday_sum or pick the one already there
      # then add any calendar punches
      # and finally make the required calculations
      #
      # anyone still at work are exempted
      #

      # run the sums of asset_work_transactions
      # punched yesterday for employees in all accounts
      Account.all.each do |account|
        Current.account = account
        Asset.all.employees.where(state: PROCESSABLE_EMPLOYEE_STATES).each do |employee_asset|
          say "....running for #{employee_asset.name}"
          dt = Rails.env.development? ? DateTime.tomorrow : DateTime.today
          employee_asset.calendar.punch_work_related_events dt.yesterday, employee_asset
          employee_asset.asset_workday_sums.where(work_date: dt.yesterday).first.calculate_on_transactions( employee_asset) rescue nil
        end
      end

    rescue => exception
      say exception
    ensure      
      say "AssetWorkdaySums done"
    end
  end
end
