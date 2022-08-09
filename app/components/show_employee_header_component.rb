# frozen_string_literal: true

class ShowEmployeeHeaderComponent < ApplicationComponent

  def initialize(title: 'title', breadcrumbs:, current:, asset:, tabs: )
    @title = title 
    @breadcrumbs = breadcrumbs
    @current= current
    @asset= asset
    @tabs = tabs
  end

  def render?
    true
  end

  
end
