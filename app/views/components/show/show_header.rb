# @markup markdown
#
# The Views::Components::Show::ShowHeader class is a component that renders the header in a show view 
#
# 
#
module Views
  class Components::Show::ShowHeader < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( title: "", breadcrumbs: "", tabs: [], css: "", &block )
      @classes = "w-full #{css} "
      @title = title
      @breadcrumbs = breadcrumbs
      @tabs = build_tabs(tabs)
    end

    def template(&)
      div( class: @classes) do
        helpers.render_component( 'resource/breadcrumb', breadcrumbs: @breadcrumbs, current: @current)
      end
      div( class: "px-4 md:flex mb-2" )do
        div( class: "relative w-full pb-5 border-b border-gray-200 sm:pb-0") do
          div( class: "md:flex md:items-center md:justify-between") do
            h2( class: "mt-2 text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate") {@title}
            div( class: "mt-3 flex md:mt-0 md:absolute md:top-3 md:right-0") do
              yield if block_given?
            end
          end
          div( class: "mt-4" )do
            div( class: "sm:hidden") do
              label( for: "current-tab", class: "sr-only") {"Select a tab"}

              select( id: "current-tab", name: "current-tab", class: "block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md") do
                @tabs.each do |tab|
                  option( value: tab[:id]) {tab[:label]}
                end
              end
            end
            div( class: "hidden sm:block" ) do
              nav( class: " -mb-px flex space-x-8") do
                @tabs.each do |tab|
                  link_to( tab[:label], tab[:url], 
                    id: tab[:id],
                    data: { tabs_target: "tab", action: tab[:action], turbo_frame: tab[:turbo_frame], content_loader_url_param: tab[:url], content_loader_target_param: tab[:turbo_frame]},
                    class: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap pb-2 px-1 border-b-2 font-medium text-sm", 
                    role: "menuitem", 
                    aria_current: "page")
                end
              end
            end
          end
        end
      end
    end

    def build_tabs tabs 
      tabs.collect do |key,value|
        {id: "#{key}_tab", url: "##{key}", label: value, action: "click->tabs#change"}
      end
    end
  end
end
