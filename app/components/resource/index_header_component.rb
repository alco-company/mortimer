# frozen_string_literal: true

class Resource::IndexHeaderComponent < ViewComponent::Base

  def initialize(form_id:, title: 'title', description: 'description', breadcrumbs:, current: )
    @form_id = form_id
    @title = title 
    @description = description
    @breadcrumbs = breadcrumbs
    @current= current
  end

  def render?
    true
  end

end
