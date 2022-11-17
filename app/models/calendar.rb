class Calendar < AbstractResource
  has_many :events 
  has_many :assets

  has_many :work_schedules, through: :events, source: "eventable", source_type: "WorkSchedule"

  def self.default_scope
    where(deleted_at: nil)
  end

end
