# frozen_string_literal: true

class Navigation::SidebarComponent < ViewComponent::Base
  def initialize(current:)
    @current = current
  end

end
