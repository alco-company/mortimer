# frozen_string_literal: true

class Resource::InputBooleanComponent < ViewComponent::Base
  def initialize(form:, field:, resource:, title:)
    @form = form
    @field = field
    @resource = resource
    @title = title
  end

end
