module EmployeesHelper
  def employee_mugshot employee, size
    if (employee.mug_shot.attached? rescue false)
      employee.mug_shot.variant(resize: size)
    else
      size.gsub!('x','/').gsub!('!','')
      "https://picsum.photos/#{size}?grayscale"
    end
  end

end
