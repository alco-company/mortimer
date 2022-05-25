# frozen_string_literal: true

class ActionButtonComponent < ViewComponent::Base
  def initialize(resource:, deleteable:, delete_url:)
    @resource = resource
    @deleteable = deleteable
    @delete_url = delete_url
  end

end
