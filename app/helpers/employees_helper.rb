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

  def show_employee_attendance_state resource, reason=''
    reason = t(reason) if reason =~ /^\./
    case resource.state
    when "IN"; "Du er mødt (stemplet ind) #{reason} #{ asset_state_time_updated resource }"
    when "OUT"; "Du er mødt ud (stemplet ud) #{reason} #{ asset_state_time_updated resource }"
    when "BREAK"; "Du gik til pause #{ asset_state_time_updated resource }"
    when "SICK"; "Du har meldt dig syg #{reason} #{ asset_state_time_updated resource }"
    when "FREE"; "Du holder fri #{reason}, siden #{ asset_state_time_updated resource } "
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

  def display_employee_state resource
    case resource.state 
    when "IN"; "er mødt (startet)"
    when "OUT"; "er mødt ud (stoppet)"
    when "BREAK"; "pauserer"
    when "SICK"; "sygemeldt"
    when "FREE"; "fri"
    when "LEAVE"; "orlov"
    else ""
    end
  end

  def display_work_today asset 
    "%s (%s)" % [display_hours_minutes(asset.asset_workday_sums.last.work_minutes),display_hours_minutes(asset.asset_workday_sums.last.break_minutes) ]
  rescue 
    "0 (0)"
  end

  def set_emp_bg_color_on_state state 
    case state
    when 'IN'; 'bg-green-100'
    when 'BREAK'; 'bg-yellow-100'
    when 'SICK'; 'bg-red-100'
    when 'OUT'; 'bg-slate-100'
    when 'FREE'; 'bg-blue-100'
    else 'bg-white'
    end
  end

  def eligible_pupils resource, params
    return resource.assetable.pupils 
  end

  def eligible_tasks resource, params
    say "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    say params    
    return resource.assetable.tasks
  end

  # 
  #  display employee access token link
  #  for POS
  #
  def display_token_link resource
    raw %(
      <button id="bat_#{dom_id(resource)}" class="grow ml-1" type="button" data-action="list#copy_text" >
        <input type="hidden" id="iat_#{dom_id(resource)}" value="#{ pos_employee_url(resource)}?api_key=#{resource.access_token}">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"></path>
        </svg>            
      </button>
    )
  end

  

end
