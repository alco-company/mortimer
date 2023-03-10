module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::RadioField < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::RadioButton

    def initialize(field, **attribs, &block )
      @resource = attribs[:resource]
      @assoc = attribs[:assoc] || nil
      @obj = @assoc.nil? ? @resource : @resource.send(@assoc)
      @field = field
      @title = attribs[:title] || I18n.translate('activerecord.attributes.' + @resource.class.to_s.underscore + '.' + field.to_s)
      @description = attribs[:description] || nil
      @required = attribs[:required] || false
      @focus = attribs[:focus] || false
      @disabled = attribs[:disabled]
      @autocomplete = attribs[:autocomplete] || "off"
      @data = attribs[:data] ||  { "form-target" => "#{'focus' if @focus}" }

      @field_value = attribs[:value] || @obj.send(@field)
      @field_name = @assoc.nil? ? "#{@resource.class.to_s.underscore}[#{@field}]" : "#{@resource.class.to_s.underscore}[#{@assoc}_attributes][#{@field}]"
      
      @buttons = attribs[:buttons] || []

      @radio_field_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5  #{attribs[:css][:radio_field] rescue ''}"
      @group_label_classes = "text-base col-span-1 font-semibold text-gray-900 #{attribs[:css][:group_label] rescue ''}"
      @group_description_classes = "text-sm col-span-2 text-gray-500 #{attribs[:css][:group_description] rescue ''}"
      @fieldset_classes = "mt-4 pt-3 col-span-2 col-start-2 #{attribs[:css][:fieldset] rescue ''}"
      @legend_classes = "sr-only #{attribs[:css][:legend] rescue ''}"
      @radio_button_classes = "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-600 #{attribs[:css][:radio_button] rescue ''}"
      @radio_button_label_classes = "ml-3 block text-sm font-medium text-gray-700 #{attribs[:css][:radio_button_label] rescue ''}"
    end

    def template()
      div class: @radio_field_classes do
        @form.label( @field, class: @group_label_classes )
        p( class: @group_description_classes ) { @description }
        fieldset( class: @fieldset_classes ) do
          legend( class: @legend_classes ) {"Notification method"}

          @buttons.each do |button|
            div( class: "space-y-4" ) do
              div( class: "flex items-top" ) do
                @form.radio_button( @field, 
                  button[:value], 
                  class: @radio_button_classes, 
                    checked: is_set?(button), 
                    required: @required, 
                    data: { "form-target" => "#{'focus' if @focus}" } )
                @form.label( @field, class: @radio_button_label_classes ) { button[:label] }
              end
            end
          end

        end
      end          
    end

    def is_set? button 
      button[:value] == @field_value ? true : false
    rescue
      false
    end
  end
end

# text_field field_name(:asset,:assetable_attributes), :pin_code, value: employee.object.pin_code