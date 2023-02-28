module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::TextArea < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::TextArea

    def initialize( resource: nil, form: nil, field: nil, title: nil, required: false, focus: false, text_css: "", label_css: "", input_css: "" )
      @resource = resource
      @form = form
      @field = field
      @title = title
      @required = required
      @focus = focus

      @text_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5 #{@text_css}"
      @label_classes = "block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 #{@label_css}"
      @input_classes = "block w-full shadow-sm sm:text-sm focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md #{@input_css}}"
    end

    def template()
      div( class: @text_classes) do
        div do
          label( @field, @title, class: @label_classes )
        end
        div( class: "sm:col-span-2") do
          text_area( :eventable, @field, class: @input_classes, required: @required)
        end
      end
    end
  end
end
