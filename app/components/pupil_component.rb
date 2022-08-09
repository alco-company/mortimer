# frozen_string_literal: true

class PupilComponent < ViewComponent::Base
  def initialize(checked:, pupil:)
    @checked = checked
    @pupil = pupil
  end

end
