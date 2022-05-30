# frozen_string_literal: true

class Navigation::MobileSidebarComponent < ViewComponent::Base
  def initialize(current:)
    @current = current
  end

end
