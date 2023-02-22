# @markup markdown
#
# The Views::Components::Show::Show class is a component that renders a show view 
#
# 
#
module Views
  class Components::Show::Show < Phlex::HTML

    def initialize( id: "", css: "", &block )
      @classes = "max-w-full lg:max-w-screen-2xl mx-auto sm:px-6 lg:px-8 #{css} "
      @id = 'show'
    end

    def template(&)
      div id: @id, class: @classes, data: { controller: "tabs", tabs: { active: { tab: "border-indigo-500 text-indigo-600"}}} do
        yield
      end
    end

  end
end
