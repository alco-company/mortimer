module EmployeesHelper

  #   image_tag "IMG_CAD0CB458651-1.jpg", class: "h-32 w-full object-cover lg:h-48"
  #   alt="Photo by <a href="https://unsplash.com/@jimmyferminphotography">Jimmy Fermin</a> on <a href="https://unsplash.com/s/photos/portrait?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  # ""
  #   <%#img class="h-32 w-full object-cover lg:h-48" src="https://images.unsplash.com/photo-1444628838545-ac4016a5418a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80" alt=""> %>
  #   <%# <img class="h-32 w-full object-cover lg:h-48" src="https://cdn.midtvest.bazo.dk/images/e3895d16-9467-4e87-a855-9bad5199bb81/d/16-9/s/1136/webp" alt=""> %>
  #
  # size: "40x40!"
  def employee_mugshot employee, size
    size = size.blank? ? "40x40!" : size
    if (employee.mug_shot.attached? rescue false)
      employee.mug_shot.variant(resize: size)
    else
      size.gsub!('x','/') if size =~ /x/
      size.gsub!('!','') if size =~ /!/
      "jimmy-fermin-bqe0J0b26RQ-unsplash.png"
    end
  end

  def show_employee_attendance_state resource
    case resource.state 
    when "IN"; "Du er mødt (startet) #{ asset_state_time_updated resource }"
    when "OUT"; "Du er mødt ud (stoppet) #{ asset_state_time_updated resource }"
    when "BREAK"; "Du har været til pause siden #{ asset_state_time_updated resource }"
    when "SICK"; "Du meldte dig syg #{ asset_state_time_updated resource }"
    end
  end

  def asset_state_time_updated resource
    l resource.updated_at, format: :time_day_date
  end

  def random_bg_pos_emp
    image_tag "ka_#{rand(1..4)}.jpg", class: "h-32 w-full object-cover lg:h-48"
  end

  def display_public name
    emp_parts = name.split " "
    "%s %s" % [emp_parts.shift, emp_parts.map{|n| n.first}.join('.')]
  end

  def set_emp_bg_color_on_state state 
    (state === 'IN' || state === 'BREAK') ? 'bg-green-200' : ''
  end

end
