module PupilsHelper

  def color_pupil resource 
    return " bg-blue-100 " if 'IN' == resource.state
    " "
  end
end
