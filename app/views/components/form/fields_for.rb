module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::FieldsFor < Phlex::HTML
    include Phlex::Rails::Helpers::FieldsFor

    def initialize( form: nil, field: nil, assoc: nil, &block )
      @form = form
      @field = field
      @assoc = assoc
    end

    def template(&)
      # # this doesn't work
      # @original_form = @form
      # @form.fields_for( @field, @assoc) do |assoc_form|
      #   begin
      #     @form = assoc_form
      #       yield
      #     end
      #   ensure
      #     @form = @original_form
      #   end
      # end
    end

    def datetime_field(**attribs, &block)
      attribs[:form] = @form
      render Views::Components::Form::DateTimeField.new( **attribs, &block)
    end
    
    def text_field(**attribs, &block)
      attribs[:form] = @form
      render Views::Components::Form::TextField.new( **attribs, &block)
    end


  end
end
