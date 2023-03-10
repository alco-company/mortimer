module Views
  #
  # the token_field component is a wrapper for the token_field 
  # sepcialization of the text_input form input field helper
  #
  class Components::Form::TokenField < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::TextField

    # arguments: field, assoc: nil, title: nil, data: {}, required: false, 
    # text_css: "", label_css: "", input_css: ""
    #
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
      @data = attribs[:data] || { "form-target" => "copytext" }

      @field_value =attribs[:value] || @obj.send(@field)
      @field_name = @assoc.nil? ? "#{@resource.class.to_s.underscore}[#{@field}]" : "#{@resource.class.to_s.underscore}[#{@assoc}_attributes][#{@field}]"

      @text_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5 #{attribs[:text_css]}"
      @label_classes = "block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 #{attribs[:label_css]}"
      @input_classes = "disabled w-full shrink shadow-sm sm:text-sm focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md  #{attribs[:input_css]}}"
    end

    def template()
      div class: @text_classes do
        div do
          if @title =~ /translation missing/i
            label( @obj, @field, class: @label_classes) { span( class:"translation_missing", title: @title) { @field.to_s } }
          else
            label( @obj, @field, @title, class: @label_classes)
          end
        end
        div( class: "sm:col-span-2 flex") do
          text_field( @obj, @field, 
            name: @field_name,
            value: @field_value,
            disabled: true,
            required: @required, 
            data: @data,
            class: @input_classes)
          button( class:"grow ml-1", type:"button", data_action:"form#copy_text") do
            svg( class:"w-6 h-6", fill:"none", stroke:"currentColor", viewBox:"0 0 24 24", xmlns:"http://www.w3.org/2000/svg") do
              path( stroke_linecap:"round", stroke_linejoin:"round", stroke_width:"2", d:"M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z")
            end
          end

          div( class:"text-sm text-red-800" ) { @obj.errors.where(@field).map( &:full_message).join( "og ") }
        end
        div( class: "col-start-2") do
          unless @obj.new_record?
            helpers.svg_qr_code_link( helpers.access_token_for(@obj))
          end
        end
      end
    end
  end
end
