# frozen_string_literal: true

class Resource::FileuploadComponent < ViewComponent::Base
  def initialize(url:, form:, field:)    
    @url= url 
    @form= form 
    @field= field
  end
  

end
