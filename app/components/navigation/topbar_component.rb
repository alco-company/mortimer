# frozen_string_literal: true

class Navigation::TopbarComponent < ViewComponent::Base
  def initialize(current:, placeholder:)
    @current = current
    @placeholder = placeholder
  end

end
