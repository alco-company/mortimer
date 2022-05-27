# frozen_string_literal: true

class Resource::ListCheckboxComponent < ViewComponent::Base
  def initialize(resource:)
    @resource = resource
  end

end
