# frozen_string_literal: true

class Navigation::MenuComponent < ViewComponent::Base
  include Turbo::StreamsHelper
  include Turbo::FramesHelper

  def initialize(current:, nav_classes:, link_classes:)
    @id = current.account.id rescue 0
    @current = current
    @nav_classes = nav_classes
    @link_classes = link_classes
  end

end
