# frozen_string_literal: true

class EditComponent < ViewComponent::Base
  def initialize(resource:, url:)
    @resource = resource
    @url = url
  end

end
