# frozen_string_literal: true

class Resource::FileuploadComponent < ViewComponent::Base
  def initialize(resource:, form:, field:, size: "40x40!")    
    @resource= resource 
    @form= form 
    @field= field
    @size= size
  end
  

end
