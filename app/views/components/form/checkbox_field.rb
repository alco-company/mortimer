module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::CheckboxField < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::Checkbox

    def initialize( field, **attribs, &block )
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

      @input_classes = "h-4 w-4 focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded #{attribs[:css][:input] rescue ''}"

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
        div do
          if @title =~ /translation missing/i
            label( @obj, @field, class: @group_label_classes) { span( class:"translation_missing", title: @title) { @field.to_s } }
          else
            label( @obj, @field, @title, class: @group_label_classes)
          end
        end
        div( class: "sm:col-span-2") do
          check_box( @obj, @field, 
            name: @field_name,
            value: @field_value,
            checked: is_checked?,
            disabled: @disabled,
            autocomplete: @autocomplete,
            required: @required, 
            data: @data,
            class: @input_classes) do |f|
              yield
            end
          div( class:"text-sm text-red-800" ) { @obj.errors.where(@field).map( &:full_message).join( "og ") }
        end

      end          
    end

    def is_checked? 
      case @field_value.class
      when Date, Time, DateTime, ActiveSupport::TimeWithZone; @field_value.present?
      when String; @field_value.present? && (@field_value != "0" && @field_value != "false")
      when Integer; @field_value != 0
      else @field_value.present?
      end
    rescue
      false
    end
  end
end

