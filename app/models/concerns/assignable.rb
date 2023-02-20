#
# thx to https://www.stevenbuccini.com/how-to-use-delegate-types-in-rails-6-1
#
#
# allows for assigning any record to an event
module Assignable
  extend ActiveSupport::Concern

  included do

    has_many :assignments, as: :assignable
    has_many :events, through: :assignments
    has_many :tasks, through: :events, source: :eventable, source_type: "Task"
    has_many :work_schedules, through: :events, source: :eventable, source_type: "WorkSchedule"
    
  end

end