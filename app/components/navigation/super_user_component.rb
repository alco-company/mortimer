# frozen_string_literal: true

class Navigation::SuperUserComponent < ViewComponent::Base
  def initialize(current:)
    @current = current
  end

end
