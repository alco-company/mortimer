# frozen_string_literal: true

class Resource::UserProfileComponent < ViewComponent::Base
  def initialize(current:, destination:, container_classes:, labelledby:)
    @current = current
    @destination = destination
    @container_classes = container_classes
    @labelledby = labelledby
  end

end
