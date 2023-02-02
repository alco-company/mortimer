# frozen_string_literal: true

class Element::AccordionComponent < ApplicationComponent

  def initialize( current:, accordions:, accordion_items:, link_classes: )
    @current = current
    @accordions = accordions
    @accordion_items = accordion_items
    @link_classes = link_classes
  end

end
