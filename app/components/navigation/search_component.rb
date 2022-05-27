# frozen_string_literal: true

class Navigation::SearchComponent < ViewComponent::Base
  def initialize(container_classes:, search_placeholder:)
    @container_classes = container_classes
    @search_placeholder = search_placeholder
  end

end
