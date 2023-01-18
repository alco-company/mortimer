#
# thx to https://www.stevenbuccini.com/how-to-use-delegate-types-in-rails-6-1
#
#
# allows for delegated_type on Asset
module Assetable
  extend ActiveSupport::Concern

  included do
    has_one :asset, as: :assetable, touch: true, dependent: :destroy

    delegate :asset_work_transactions, :asset_workday_sums, :teams, :name, :calendar, :account, :state, :tasks, :work_schedules, :deleted_at, :deleted_at=, to: :asset
  
    def delegated_from
      self.asset
    end

    def self.delegated_from
      Asset
    end
    
  end

end