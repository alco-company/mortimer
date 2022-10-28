# allows for delegated_type on Event
module Eventable
  extend ActiveSupport::Concern

  included do
    has_one :event, as: :eventable, touch: true, dependent: :destroy
    has_many :assignments, through: :event
    accepts_nested_attributes_for :assignments, reject_if: :all_blank, allow_destroy: true

    delegate :name, :calendar, :account, :state, :deleted_at, to: :event
  
    def delegated_from
      self.event
    end

    def self.delegated_from
      Event
    end
    
  end

end