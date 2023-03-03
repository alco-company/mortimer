# @markup markdown
#
# The Views::Components::Show::Show class is a component that renders a show view 
#
# 
#
module Views
  class Components::Breadcrumbs < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( breadcrumbs: [])
      @breadcrumbs = breadcrumbs
    end

    def template()
      nav( id: "breadcrumb_strip", class: "px-4 pt-4 flex", aria_label: "Breadcrumb") do
        ol( role: "list", class: "flex items-center space-x-4") do
          if !Current.account.nil? && (Current.account != Current.user.account)
            li {link_to( Current.account.name, "/", class: "text-sm font-medium text-blue-800 hover:text-blue-900")}
          else
            li do
              div do
                link_to( helpers.root_path, class: "text-gray-400 hover:text-gray-500") do
                  #  <!-- Heroicon name: solid/home -->
                  svg( class: "flex-shrink-0 h-5 w-5", xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                    path( d: "M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z")
                  end
                  span( class: "sr-only") {Dashboard}
                end
              end
            end
          end

          @breadcrumbs[1..].each do |crumb|
            li() do
              div( class: "flex items-center") do
                svg( class: "flex-shrink-0 h-5 w-5 text-gray-300", xmlns: "http://www.w3.org/2000/svg", fill: "currentColor", viewBox: "0 0 20 20", aria_hidden: "true") do
                  path( d: "M5.555 17.776l8-16 .894.448-8 16-.894-.448z")
                end
                a( href: "#{crumb[:url]}", class: "ml-4 text-sm font-medium text-gray-500 hover:text-gray-700") {crumb[:label]}
              end
            end
          end unless @breadcrumbs.nil?
        end
      end
    end

  end
end
