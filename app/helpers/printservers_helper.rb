module PrintserversHelper

  def display_printserver_state resource
    case resource.state 
    when "OFF"; "aktiv"
    when "ON"; "passiv"
    else ""
    end
  end

end
