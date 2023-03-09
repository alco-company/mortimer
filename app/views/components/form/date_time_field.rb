module Views
  #
  # the date_time_field component is a wrapper for the date_field form input field helper
  #
  class Components::Form::DateTimeField < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::DateTimeField

    # arguments: field, assoc: nil, title: nil, data: {}, required: false, focus: false, disabled: false, 
    # date_css: "", label_css: "", input_css: ""
    def initialize( field, **attribs, &block )
      @resource = attribs[:resource]
      @assoc = attribs[:assoc] || nil
      @obj = @assoc.nil? ? @resource : @resource.send(@assoc)
      @field = field
      @title = attribs[:title] || I18n.translate('activerecord.attributes.' + @resource.class.to_s.underscore + '.' + field.to_s)
      @required = attribs[:required] || false
      @focus = attribs[:focus] || false
      @disabled = attribs[:disabled]
      @data = attribs[:data] ||  { "form-target" => "#{'focus' if @focus}" }
      @field_value = @assoc.nil? ? @resource.send(@field) : @resource.send(@assoc).send(@field)
      @field_value = @field_value.strftime "%Y-%m-%dT%T" unless @field_value.nil?
      @field_name = @assoc.nil? ? "#{@resource.class.to_s.underscore}[#{@field}]" : "#{@resource.class.to_s.underscore}[#{@assoc}_attributes][#{@field}]"
      @date_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5 #{attribs[:date_css]}"
      @label_classes = "block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 #{attribs[:label_css]}"
      @input_classes = "block w-full shadow-sm sm:text-sm focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md #{attribs[:input_css]}}"
    end

    def template(&)
      div class: @date_classes do
        div do
          if @title =~ /translation missing/i
            label( @obj, @field, class: @label_classes) { span( class:"translation_missing", title: @title) { @field.to_s } }
          else
            label( @obj, @field, @title, class: @label_classes)
          end
        end
        div( class: "sm:col-span-2") do
          datetime_field( @obj, @field, 
            name: @field_name,
            value: @field_value,
            disabled: @disabled,
            required: @required, 
            data: @data,
            step: 60,
            class: @input_classes)
          div( class:"text-sm text-red-800" ) { @resource.errors.where(@field).map( &:full_message).join( "og ") }
        end
      end
    end
  end
end
