#
# thx to https://www.stevenbuccini.com/how-to-use-delegate-types-in-rails-6-1
#
#
# allows for delegated_type on Asset
module Assignable
  extend ActiveSupport::Concern

  included do

    has_many :assignments, as: :assignable
    has_many :events, through: :assignments
    has_many :tasks, through: :events, source: :eventable, source_type: "Task"
    
  end

end