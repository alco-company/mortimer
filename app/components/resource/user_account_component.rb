# frozen_string_literal: true

class Resource::UserAccountComponent < ViewComponent::Base
  def initialize(current:)
    @current = current
  end

end
