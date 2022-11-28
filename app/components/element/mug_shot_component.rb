# frozen_string_literal: true

class Element::MugShotComponent < ApplicationComponent

  def initialize( resource:, claz: nil )
    @resource = resource 
    @class = claz.nil? ? "grid h-10 w-10 rounded-full drop-shadow-sm place-items-center bg-slate-200" : claz
    if resource.mug_shot.persisted?
      @url = resource.mug_shot 
    else
      @url = nil
    end
  end

end
