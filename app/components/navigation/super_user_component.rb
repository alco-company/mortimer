# frozen_string_literal: true

class Navigation::SuperUserComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

end
