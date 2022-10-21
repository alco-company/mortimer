# frozen_string_literal: true

class ButtonToComponent < ViewComponent::Base
  def initialize(url:, css: )
    @url = url
    @css = css
  end

end
