module EquipmentHelper

  def display_equipment_state resource
    case resource.state 
    when "INACTIV"; "ude af drift"
    when "MAINT"; "for øjeblikket til reparation"
    when "WORK"; "igang/ibrug"
    when "VACANT"; "ledigt/holder stille"
    else ""
    end
  end

end
