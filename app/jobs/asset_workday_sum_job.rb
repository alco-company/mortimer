class AssetWorkdaySumJob < ApplicationJob
  queue_as :default

  PROCESSABLE_EMPLOYEE_STATES = ['OUT','SICK','FREE','OUT']

  def perform(*args)
    begin     
      say "Running AssetWorkdaySums for yesterday against Calendars and AssetWorkTransactions"
      Employee.unscoped.where(state: PROCESSABLE_EMPLOYEE_STATES).each do |employee|
        dt = Date.parse( DateTime.current.to_s)
        awts = employee.asset_workday_sums.where(work_date: dt.yesterday)
      end

      # AssetWorkdaySum.unscoped.where(work_date: dt.yesterday).

    rescue => exception
      say exception
    ensure      
      say "FISK done"
    end
  end
end
