# frozen_string_literal: true

class Resource::ShowHeaderComponent < ViewComponent::Base

  def initialize(title: 'title', breadcrumbs:, current:, tabs: )
    @title = title 
    @breadcrumbs = breadcrumbs
    @current= current
    @tabs = tabs
  end

  def render?
    true
  end

  
end
