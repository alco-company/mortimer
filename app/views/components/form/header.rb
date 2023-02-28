module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::Header < Phlex::HTML

    def initialize( resource: "", title: "", description: "" )
      @resource = resource
      @title = title
      @description = description
      @classes = "h-full flex flex-col bg-white shadow-xl overflow-y-scroll #{@css}"
    end

    def template(&)
      div( class: "sticky z-20 top-0 right-0 px-4 py-6 bg-gray-50 sm:px-6" ) do
        div( class: "flex items-start justify-between space-x-3" ) do
          div( class: "space-y-1" ) do
            h2( class: "text-lg font-medium text-gray-900", id: "slide-over-title" ) { @title }
            p( class: "text-sm text-gray-500" ) { @description }
          end
          div( class: "h-7 flex items-center" ) do
            # render partial: "shared/components/close_x", locals: { action: "form-sleeve#cancel", sr: 'close form', css_class: "text-gray-400 hover:text-gray-500" }
            button type: "button", data: { action: "form-sleeve#cancel"}, class: "text-gray-400 hover:text-gray-500"  do
              span( class: "sr-only", sr: "close form")
              # <!-- Heroicon name: outline/x -->
              svg( class: "h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", aria_hidden: "true") do
                path( stroke: { linecap: "round", linejoin: "round", width: "2" }, d: "M6 18L18 6M6 6l12 12" )
              end
            end
          end
        end
      end
    end
  end
end
