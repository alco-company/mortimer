# frozen_string_literal: true

class Navigation::ServiceComponent < ViewComponent::Base
  with_collection_parameter :service

  def initialize(service:, current:, css:)
    @service = service
    @current = current
    @css = css
  end

end
