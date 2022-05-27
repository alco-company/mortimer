# frozen_string_literal: true

class Resource::BreadcrumbComponent < ViewComponent::Base
  def initialize(breadcrumbs:, current:)
    @breadcrumbs = breadcrumbs
    @current = current
  end

end
