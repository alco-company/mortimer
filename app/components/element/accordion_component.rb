# frozen_string_literal: true

class Element::AccordionComponent < ApplicationComponent

  def initialize( user:, index:, accordions:, accordion_items:, link_classes: )
    @user = user
    @index_starts_at = index
    @accordions = accordions
    @accordion_items = accordion_items
    @link_classes = link_classes
  end

end
