# @markup markdown
#
# The Views::Components::Show::TabHeader class is a component that renders a tab header in a tab
# (in the show view).
#
# 
#
module Views
  class Components::Show::DictionaryItem < Phlex::HTML

    def initialize( label: "", value: "", css: "", &block )
      @classes = "py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 #{css} "
      @label = label
      @value = value
    end

    def template(&)
      div( class: @classes) do
        dt( class: "text-sm font-medium text-gray-500") {@label}
        dd( class: "mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2") {"#{@value}"}
      end
    end

  end
end
