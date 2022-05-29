# frozen_string_literal: true

class Resource::FormHeaderComponent < ViewComponent::Base
  def initialize(resource:, title:, description:)
    @resource = resource
    @title = title
    @description = description
  end

end
