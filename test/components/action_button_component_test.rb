# frozen_string_literal: true

require "test_helper"

class ActionButtonComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    # assert_equal(
    #   %(<span>Hello, components!</span>),
    #   render_inline(ActionButtonComponent.new(message: "Hello, components!")).css("span").to_html
    # )
    render_inline ActionButtonComponent.new resource: Dashboard.new, deleteable: true, delete_url: '/dashboards'
    assert_selector "div", class: "sticky"
    assert_selector "button", class: "button"
  end
end
