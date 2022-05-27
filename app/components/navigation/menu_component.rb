# frozen_string_literal: true

class Navigation::MenuComponent < ViewComponent::Base
  def initialize(nav_classes:, link_classes:, current:)
    @current = current
    @nav_classes = nav_classes
    @link_classes = link_classes
    @id = 1
  end

end
