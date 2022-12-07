#                                           STATE
# t.date "work_date"
# t.integer "work_minutes"                  IN
# t.integer "break_minutes"                 BREAK
# t.integer "ot1_minutes"                   IN          X
# t.integer "ot2_minutes"                   IN          X after 180min OT1
# t.integer "sick_minutes"                  SICK
# t.integer "free_minutes"                  FREE        
# t.integer "holiday_free_minutes"          FREE        RR
# t.integer "child_sick_minutes"            SICK        CHILD
# t.integer "nursing_minutes"               SICK        NURSING
# t.integer "senior_minutes"                FREE        SENIOR
# t.integer "unpaid_free_minutes"           FREE        UNPAID
# t.integer "lost_work_revenue_minutes"     SICK        LOST_WORK
# t.integer "child_leave_minutes"           FREE        MATERNITY
# t.integer "leave_minutes"                 FREE        LEAVE
# t.integer "free_prev_minutes" <-- when year = +1
# t.integer "pgf56_minutes"                 SICK        P56
# t.datetime "created_at", null: false

class AssetWorkdaySum < AbstractResource
  belongs_to :account
  belongs_to :asset
  has_many :asset_work_transactions

  def broadcast_create

  end
  def broadcast_update
    
  end

  # find all asset_work_transactions and
  # increment all counters
  def calculate_on_transactions punched_by_asset, prev_year_awd

    # t.bigint "asset_id", null: false
    # t.bigint "asset_workday_sum_id"
    # t.bigint "punch_asset_id"
    # t.string "punch_asset_ip_addr"
    # t.datetime "punched_at"
    # t.integer "extra_time"
    # t.datetime "created_at", null: false
    from = punch_type = nil
    reset_values    

    awts = asset_work_transactions.includes(:event).references(:event).order(punched_at: :asc)
    awts.each do |awt|
      case awt.state 

      # work_minutes
      # ot1_minutes
      # ot2_minutes
      when 'IN'
        calc_last_stint awt, from, punch_type
        from = awt.punched_at
        punch_type = :work_minutes 

      # break_minutes
      when 'BREAK'
        calc_last_stint awt, from, punch_type
        from = awt.punched_at
        punch_type = :break_minutes

      # sick_minutes
      # child_sick_minutes
      # nursing_minutes
      # lost_work_revenue_minutes
      # pgf56_minutes
      # child_leave_minutes
      when 'SICK'
        calc_last_stint awt, from, punch_type
        from = awt.punched_at
        punch_type = :sick_minutes


      # free_minutes
      # free_prev_minutes
      # holiday_free_minutes
      # senior_minutes
      # unpaid_free_minutes
      # leave_minutes
      when 'FREE'
        calc_last_stint awt, from, punch_type
        from = awt.punched_at
        punch_type = :free_minutes

      when 'OUT'
        calc_last_stint awt, from, punch_type
        from = nil
        punch_type = nil

      end

      say "awt - #{awt.state}, #{awt.punched_at }"
    end

    say "processed #{awts.count} punches........"
    # move any free_minutes to free_prev_minutes
    # next year on this day
    if prev_year_awd
      self.update_column :free_prev_minutes, prev_year_awd.free_minutes
    end
    
  rescue Exception => e
    puts e
  end

  #
  # we will calculate the number of minutes
  # they spent on this last stint doing whatever
  # by looking at the current awt.punched_at and the from datetime
  #
  def calc_last_stint awt, from, punch_type
    return if from.nil?
    minutes = calc_minutes from, awt.punched_at
    unless calc_work(minutes,punch_type)
      minutes += self.attributes[punch_type.to_s]
      self.update_column punch_type, minutes
    end
    from = nil
  end

  def calc_minutes from, to
    minutes = 0
    unless (from.nil? and to.nil?)
      from = from.to_time #if from.respond_to? :to_time
      to = to.to_time #if to.respond_to? :to_time
      # from,to = to, from if from > to
      minutes = ((to - from) / 60).round
    end
    minutes
  end

  def calc_work minutes, punch_type      
    return false unless %w( work_minutes ot1_minutes ot2_minutes ).include? punch_type.to_s

    minutes = work_minutes + minutes
    if minutes > (asset.assetable.norm_time * 60 / 5).round
      minutes = work_minutes - (asset.assetable.norm_time * 60 / 5).round
      update_column :work_minutes, (asset.assetable.norm_time * 60 / 5).round
      punch_type = :ot1_minutes
    else
      update_column :work_minutes, minutes
    end

    # if ot1_minutes
    if %w( ot1_minutes ot2_minutes ).include? punch_type.to_s
      t1 = ot1_minutes + minutes 
      t2 = t1 - 180
      update_column :ot1_minutes, t1 < 181 ? t1 : 180
      update_column :ot2_minutes, t2 if t2 > 0
    end
    return true

  end

  def reset_values
    self.work_minutes = 0
    self.ot1_minutes = 0
    self.ot2_minutes = 0
    self.break_minutes = 0
    self.sick_minutes = 0
    self.child_sick_minutes = 0
    self.nursing_minutes = 0
    self.lost_work_revenue_minutes =0
    self.pgf56_minutes = 0
    self.child_leave_minutes = 0
    self.free_minutes = 0
    self.holiday_free_minutes = 0
    self.senior_minutes = 0
    self.unpaid_free_minutes = 0
    self.leave_minutes = 0
    save
  end

end
