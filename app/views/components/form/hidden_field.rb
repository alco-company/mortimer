module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::HiddenField < Phlex::HTML
    include Phlex::Rails::Helpers::HiddenField

    def initialize( resource: nil, form: nil, field: nil, value: nil )
      @resource = resource.class.to_s.underscore
      @form = form
      @field = field
      @value = value
    end

    def template()
      # this doesn't work
      @form.hidden_field @field, value: @value
    end
  end
end
