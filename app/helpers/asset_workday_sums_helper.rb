module AssetWorkdaySumsHelper

  def display_hours_minutes minutes 
    minutes_left = minutes.to_i % 60
    "%02d:%02d" % [ minutes.to_i/60, minutes_left ]
  rescue 
    "-"
  end

end
