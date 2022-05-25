module Parentings

  # # add the child to an association of children
  # !! remember to implement before_save action on *able tables to meet further foreign_key conditions like account_id, etc
  def attach parent

    # the ordinary *able table
    parent.send( self.class.to_s.underscore.pluralize) << self

    # case child.class.to_s
    # when "Event","WageEvent"
    #   Eventable.create( event: child, eventable: self) unless child.eventables.include?( self)
    # when "Printer"
    #   Printable.create( printer: child, printable: self) unless child.printables.include?( self)
    # else
    #   children = eval child.class.to_s.underscore.pluralize
    #   children << child
    # end
  rescue
    false
  end
  #
  # # remove the child from an association of children
  def detach parent

    # the ordinary *able table
    parent.send( self.class.to_s.underscore.pluralize).delete self

    # case child.class.to_s
    # when "Event","WageEvent"
    #   ev = Eventable.where( event: child, eventable: self)
    #   ev.delete_all
    # when "Printer"
    #   pr = Printable.where( printer: child, printable: self)
    #   pr.delete_all
    # else
    #   children = eval child.class.to_s.underscore.pluralize
    #   children.delete child
    # end
  rescue
    false
  end

end