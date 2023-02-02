# frozen_string_literal: true

class Navigation::ServiceComponent < ViewComponent::Base
  with_collection_parameter :service

  def initialize(service:, user:, css:)
    @service = service
    @user = user
    @css = css
  end

end
