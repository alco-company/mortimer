# frozen_string_literal: true

class Resource::IndexTableComponent < ViewComponent::Base
  with_collection_parameter :item

  def initialize(item:)
    @item = item
  end
end
