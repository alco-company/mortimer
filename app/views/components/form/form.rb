module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::Form < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::FieldsFor

    def initialize( resource: nil, css: "", &block )
      @resource = resource
      @classes = "h-full flex flex-col bg-white shadow-xl overflow-y-scroll #{@css}"
    end

    def template(&)
      form_with( model: @resource, 
        url: helpers.resource_url(), 
        id: helpers.resource_form, 
        enctype: "multipart/form-data",
        data: { form_sleeve_target: 'form' }, class: @classes) do |form|
        @rails_form_builder = form
        yield
      end
    end

    def form_builder
      @rails_form_builder
    end

    def fields_for(*args, **kwargs) # takes a block (we don't need to specify that because we're yielding)
      # save the current value of @form. We'll need it later.
      original_form = @rails_form_builder
      
      begin
        # render Views::Components::Form::FieldsFor.new( form: @rails_form_builder, field: field, assoc: assoc, &block)
        # temporarily set @form to point to the fields_for form builder
        @rails_form_builder.fields_for(*args, **kwargs) do |f|
          @rails_form_builder = f

          # yield the component while it has @from scoped to the fields_for form builder
          yield(self)
        end
      ensure
        # set the form back to the original form before scoping it
        @rails_form_builder = original_form
      end
    end

    def text_field(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::TextField.new **attribs, &block
    end

    def token_field(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::TokenField.new **attribs, &block
    end

    def radio_field(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::RadioField.new **attribs, &block
    end

    def hidden_field(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::HiddenField.new **attribs, &block
    end

    def text_area(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::TextArea.new **attribs, &block
    end

    def datetime_field(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::DateTimeField.new **attribs, &block
    end

    def combo_field(**attribs, &block)
      attribs[:form] = @rails_form_builder
      render Views::Components::Form::ComboField.new **attribs, &block
    end

  end
end
