module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::HiddenField < Phlex::HTML
    include Phlex::Rails::Helpers::HiddenField

    def initialize( **attribs, &block )
      @form = attribs[:form]
      @field = attribs[:field]
      @value = attribs[:value]
    end

    def template()
      # this doesn't work
      @form.hidden_field @field, value: @value
    end
  end
end
