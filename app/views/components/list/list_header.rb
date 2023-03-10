# @markup markdown
#
# The Views::Components::List::ListHeader class is a component that renders the header on lists (#index on controllers).
#
#
module Views
  class Components::List::ListHeader < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( title: "", description: '', breadcrumbs: [], current: '', id: 'index_header' )
      @title = title
      @description = description
      @breadcrumbs = breadcrumbs
      @id = id
    end

    def template(&)
      div( class: "w-full") do
        # helpers.render_component 'resource/breadcrumb', breadcrumbs: @breadcrumbs, current: @current
        helpers.render_breadcrumbs( breadcrumbs: @breadcrumbs)
      end
      div( id: @id, class: "relative px-4 md:flex") do
        div( class: "md:w-1/2 lg:w-3/5 xl:w-2/3") do
          h2( class: "mt-2 text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate") {@title}
          div( class: "mt-1 sm:mt-0 sm:space-x-6") do 
            div( class: "mt-2 flex items-center text-sm text-gray-500") {@description}
          end
        end

        #search_and_more_button classes: "relative inline-block text-left flex md:absolute md:top-10 md:right-2"

      end
    end

    def search_and_more_button(**attribs, &block)
      render Views::Components::SearchAndMoreButton.new **attribs, &block
    end
  end
end
