module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::TokenField < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::TextField

    def initialize( resource: nil, form: nil, field: nil, title: nil, data: {}, required: false, focus: false, disabled: false, text_css: "", label_css: "", input_css: "" )
      @resource = resource
      @form = form
      @field = field
      @title = title
      @required = required
      @focus = focus
      @disabled = disabled
      @data = data
      @field_value = resource.send(@field)
      @text_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5 #{@text_css}"
      @label_classes = "block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 #{@label_css}"
      @input_classes = "disabled w-full shrink shadow-sm sm:text-sm focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md #{@input_css}}"
    end

    def template()
      div class: @text_classes do
        div do
          @form.label( @field, class: @label_classes)
        end
        div( class: "sm:col-span-2 flex") do
          @form.text_field @field, 
            value: @field_value,
            disabled: true, 
            data: { "form-target" => "copytext" },
            class: @input_classes 
          button( class:"grow ml-1", type:"button", data_action:"form#copy_text") do
            svg( class:"w-6 h-6", fill:"none", stroke:"currentColor", viewBox:"0 0 24 24", xmlns:"http://www.w3.org/2000/svg") do
              path( stroke_linecap:"round", stroke_linejoin:"round", stroke_width:"2", d:"M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z")
            end
          end

          div( class:"text-sm text-red-800" ) { @resource.errors.where(@field).map( &:full_message).join( "og ") }
        end
        div( class: "col-start-2") do
          unless @resource.new_record?
            helpers.svg_qr_code_link( helpers.access_token_for(@form.object))
          end
        end
      end
    end
  end
end
