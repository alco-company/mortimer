# frozen_string_literal: true

class Resource::FileuploadComponent < ViewComponent::Base
  def initialize(resource:, form:, field:)    
    @resource= resource 
    @form= form 
    @field= field
  end
  

end
