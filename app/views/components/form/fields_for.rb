module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::FieldsFor < Phlex::HTML
    include Phlex::Rails::Helpers::FieldsFor

    def initialize( form: nil, field: nil, assoc: nil )
      @form = form
      @field = field
      @assoc = assoc
    end

    def template(&)
      # this doesn't work
      @form.fields_for @field do |assoc_form|
        div( class: "flex-1 relative ", data: { 
            controller: "form", 
            form_form_sleeve_outlet: "#form-sleeve", 
            form_list_outlet: "#list", 
            action: "keydown->form#keydownHandler speicherMessage@window->form#handleMessages" 
          } ) do  
        yield(assoc_form)
        end
      end
    end
  end
end
