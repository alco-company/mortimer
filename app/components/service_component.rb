# frozen_string_literal: true

class ServiceComponent < ViewComponent::Base
  def initialize(checked:, service:)
    @checked = checked
    @service = service
  end

end
