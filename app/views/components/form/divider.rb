module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::Divider < Phlex::HTML

    def initialize( css: "" )
      @classes = "h-full py-6 space-y-6 sm:py-0 sm:space-y-0 sm:divide-y sm:divide-gray-200 #{@css}"
    end

    def template(&)
      div( class: @classes ) do
        yield
      end
    end
  end
end
