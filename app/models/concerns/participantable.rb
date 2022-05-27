#
# thx to https://www.stevenbuccini.com/how-to-use-delegate-types-in-rails-6-1
#
#
# allows for delegated_type on Asset
module Participantable
  extend ActiveSupport::Concern

  included do
    has_one :participant, as: :participantable, touch: true, dependent: :destroy

    delegate :name, :state, :roles, :teams, :deleted_at, to: :participant

    # ---
    #
    # used by resource_control to decide whether to create 
    # base-resources or delegated_from ditto
    #
    def delegated_from
      self.participant
    end

    def self.delegated_from
      Participant
    end
    #
    # ---
  
  end

end