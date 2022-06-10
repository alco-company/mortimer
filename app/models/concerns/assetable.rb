#
# thx to https://www.stevenbuccini.com/how-to-use-delegate-types-in-rails-6-1
#
#
# allows for delegated_type on Asset
module Assetable
  extend ActiveSupport::Concern

  included do
    has_one :asset, as: :assetable, touch: true, dependent: :destroy

    delegate :name, :calendar, :account, :state, :deleted_at, to: :asset
  
    def delegated_from
      self.asset
    end

    def self.delegated_from
      Asset
    end
    
  end

end