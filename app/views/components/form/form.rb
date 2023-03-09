module Views
  #
  # the form component is a wrapper for the form_with form helper
  # and it handles nested forms by adding an argument - assoc - to the initializer
  # another argument supports the clipboard prefix - copy/pasting of form field values
  #
  # Caveats: the form will not support deep nested forms - ie only one level of nesting!
  #
  class Components::Form::Form < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::FieldsFor

    def initialize( resource: nil, assoc: nil, clipboard_prefix: nil, css: "", &block )
      @resource = resource
      @assoc = assoc
      @clipboard_prefix = clipboard_prefix
      @classes = "h-full flex flex-col bg-white shadow-xl overflow-y-scroll #{@css}"

      @form = nil
    end

    def template(&)
      form_with( model: @resource, 
        url: helpers.resource_url(), 
        id: helpers.resource_form, 
        enctype: "multipart/form-data",
        data: { form_sleeve_target: 'form' }, class: @classes) do |form|
          @form = form
          hidden_field( :account_id, value: Current.account.id )
          unless @assoc.nil?
            hidden_field( "#{@assoc}_type", value: @resource.send(@assoc).class.to_s) 
            hidden_field( :id, assoc: :assetable) 
          end
          div( 
            class:"flex-1 relative ",
            data_controller: "form",
            data_form_form_sleeve_outlet: "#form-sleeve",
            data_form_list_outlet: "#list",
            data_form_clipboard_prefix_value: @clipboard_prefix,
            data_action: "keydown->form#keydownHandler speicherMessage@window->form#handleMessages"
            ) do
              yield
          end
        end
    end

    def text_field(field, **attribs, &block)
      attribs[:resource] ||= @resource
      render Views::Components::Form::TextField.new field, **attribs, &block
    end

    def token_field(field, **attribs, &block)
      attribs[:resource] ||= @resource
      render Views::Components::Form::TokenField.new field, **attribs, &block
    end

    def radio_field(field, **attribs, &block)
      attribs[:resource] ||= @resource
      render Views::Components::Form::RadioField.new field, **attribs, &block
    end

    def hidden_field( field, **attribs)
      attribs[:resource] ||= @resource
      render Views::Components::Form::HiddenField.new field, **attribs
    end

    def text_area(field, **attribs, &block)
      attribs[:resource] ||= @resource
      render Views::Components::Form::TextArea.new field, **attribs, &block
    end

    def datetime_field(field, **attribs, &block)
      attribs[:resource] ||= @resource
      render Views::Components::Form::DateTimeField.new field, **attribs, &block
    end

    def combo_field(field, **attribs, &block)
      attribs[:resource] ||= @resource
      render Views::Components::Form::ComboField.new field,  **attribs, &block
    end

  end
end
