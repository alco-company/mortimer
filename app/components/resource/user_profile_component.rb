# frozen_string_literal: true

class Resource::UserProfileComponent < ViewComponent::Base
  def initialize(current:, container_classes:, labelledby:)
    @current = current
    @container_classes = container_classes
    @labelledby = labelledby
  end

end
