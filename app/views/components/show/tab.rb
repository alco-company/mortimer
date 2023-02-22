# @markup markdown
#
# The Views::Components::Show::Tab class is a component that renders a tab (in the show view).
#
# 
#
module Views
  class Components::Show::Tab < Phlex::HTML

    def initialize( id: "", css: "", &block )
      @classes = "hidden px-4 py-4 #{css} "
      @id = id
    end

    def template(&)
      div id: @id, class: @classes, data: { tabs: {target: "panel"}} do
        div class: "bg-white shadow overflow-hidden sm:rounded-lg" do
          yield
        end
      end
    end

  end
end
