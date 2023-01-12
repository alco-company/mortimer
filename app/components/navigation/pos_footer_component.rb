# frozen_string_literal: true

class Navigation::PosFooterComponent < ViewComponent::Base
  include Turbo::StreamsHelper
  include Turbo::FramesHelper

  def initialize( links: )
    @links = links
  end

end
