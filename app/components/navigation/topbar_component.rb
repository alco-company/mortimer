# frozen_string_literal: true

class Navigation::TopbarComponent < ViewComponent::Base
  def initialize(current_user:, placeholder:)
    @current_user = current_user
    @placeholder = placeholder
  end

end
