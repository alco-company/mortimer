module EmployeesHelper
  def employee_mugshot employee, size
    if (employee.mug_shot.attached? rescue false)
      employee.mug_shot.variant(resize: size)
    else
      size.gsub!('x','/').gsub!('!','')
      "https://picsum.photos/#{size}?grayscale"
    end
  end

  def show_employee_attendance_state resource
    case resource.state 
    when "in"; "Du er mødt (startet) #{ asset_state_time_updated resource }"
    when "out"; "Du er mødt ud (stoppet) #{ asset_state_time_updated resource }"
    when "pause"; "Du har været til pause siden #{ asset_state_time_updated resource }"
    when "sick"; "Du meldte dig syg #{ asset_state_time_updated resource }"
    end
  end

  def asset_state_time_updated resource
    l resource.updated_at, format: :time_day_date
  end

end
