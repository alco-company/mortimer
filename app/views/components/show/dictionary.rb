# @markup markdown
#
# The Views::Components::Show::TabHeader class is a component that renders a tab header in a tab
# (in the show view).
#
# 
#
module Views
  class Components::Show::Dictionary < Phlex::HTML

    def initialize( css: "", &block )
      @classes = "border-t border-gray-200 px-4 py-5 sm:p-0 #{css} "
    end

    def template(&)
      div( class: @classes) do
        dl( class: "sm:divide-y sm:divide-gray-200") do
          yield
        end
      end
    end

  end
end

