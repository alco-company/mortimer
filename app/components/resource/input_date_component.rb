# frozen_string_literal: true

class Resource::InputDateComponent < ViewComponent::Base
  def initialize(form:, field:, resource:, title:, focus: false, required: false)
    @form = form
    @field = field
    @resource = resource
    @title = title
    @focus = focus
    @required = required
  end
end
