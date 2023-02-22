# @markup markdown
#
# The Views::Components::Show::TabHeader class is a component that renders a tab header in a tab
# (in the show view).
#
# 
#
module Views
  class Components::Show::TabHeader < Phlex::HTML

    def initialize( label: "", description: "", css: "", &block )
      @classes = "px-4 py-5 sm:px-6 #{css} "
      @label = label
      @description = description
    end

    def template(&)
      div class: @classes do
        h3 class: "text-lg leading-6 font-medium text-gray-900" do
          @label
        end
        p class: "mt-1 max-w-2xl text-sm text-gray-500" do
          @description
        end
      end
    end

  end
end


