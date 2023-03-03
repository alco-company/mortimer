# @markup markdown
#
# The Views::Components::List::ListHeader class is a component that renders the header on lists (#index on controllers).
#
#
module Views
  class Components::List::ListHeader < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( title: "", description: '', breadcrumbs: [], current: '' )
      @title = title
      @description = description
      @breadcrumbs = breadcrumbs
    end

    def template(&)
      div( class: "w-full") do
        # helpers.render_component 'resource/breadcrumb', breadcrumbs: @breadcrumbs, current: @current
        helpers.render_breadcrumbs( breadcrumbs: @breadcrumbs)
      end
      div( id: "index_header", class: "relative px-4 md:flex") do
        div( class: "md:w-1/2 lg:w-3/5 xl:w-2/3") do
          h2( class: "mt-2 text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate") {@title}
          div( class: "mt-1 sm:mt-0 sm:space-x-6") do 
            div( class: "mt-2 flex items-center text-sm text-gray-500") {@description}
          end
        end
        # div( class: "flex md:absolute md:top-10 md:right-5 2xl:right-[5%]") do
        #   button( class: "w-10 h-10 shadow-md rounded-full align-center hover:text-slate-50 text-slate-300 hover:bg-slate-300 bg-slate-100") do 
        #     span( class: "h-5 w-5 material-symbols-outlined") {"more_vert"}
        #   end
        # end
        div( 
          class: "relative inline-block text-left flex md:absolute md:top-10 md:right-2 ",
          id: "list_more_menu_component",
          data_controller: "more",
          ) do
          div do
            button( 
              type: "button", 
              class: "h-10 w-10 flex items-center rounded-full bg-gray-100 text-gray-300 hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-gray-100", 
              data_action: "click->more#toggle",
              id: "menu-button", 
              aria_expanded: "true", 
              aria_haspopup: "true"
              ) do
              span( class: "sr-only") {"Open options"}
              # span( class: "h-5 w-5 material-symbols-outlined") {"more_vert"}
              svg( class: "h-8 w-8 align-center ml-1", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                path( d: "M10 3a1.5 1.5 0 110 3 1.5 1.5 0 010-3zM10 8.5a1.5 1.5 0 110 3 1.5 1.5 0 010-3zM11.5 15.5a1.5 1.5 0 10-3 0 1.5 1.5 0 003 0z" )
              end
            end
          end
          
          # Dropdown menu, show/hide based on menu state.
          # 
          # Entering: "transition ease-out duration-100"
          # From: "transform opacity-0 scale-95"
          # To: "transform opacity-100 scale-100"
          # Leaving: "transition ease-in duration-75"
          # From: "transform opacity-100 scale-100"
          # To: "transform opacity-0 scale-95"
          # 
          div( class: "hidden absolute right-0 z-10 mt-12 w-56 origin-top-right divide-y divide-gray-100 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none", 
            id: "list_more_menu",
            data_more_target: "listmoremenu",
            role: "menu", 
            aria_orientation: "vertical", 
            aria_labelledby: "menu-button", 
            data_action: "click->more#toggle",
            tabindex: "-1"
            ) do
            div( class: "py-1", role: "none") do
              # <!-- Active: "bg-gray-100 text-gray-900", Not Active: "text-gray-700" I18n.t("#{helpers.resource_class}.new_button"),  -->
              link_to( helpers.new_resource_url, role: "menuitem", tabindex: "-1", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", data: { form_sleeve_target: "button",  switchboard_url_param: "#{helpers.new_resource_url}", action: "switchboard#newForm", 'turbo-frame': 'form_slideover' }) do
              # a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-0") do
                span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"add"}
                # svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                #   path( d: "M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" )
                #   path( d: "M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" )
                # end
                span {"Add"}
              end
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-1") do
                span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"search"}
                # svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                #   path( d: "M7 3.5A1.5 1.5 0 018.5 2h3.879a1.5 1.5 0 011.06.44l3.122 3.12A1.5 1.5 0 0117 6.622V12.5a1.5 1.5 0 01-1.5 1.5h-1v-3.379a3 3 0 00-.879-2.121L10.5 5.379A3 3 0 008.379 4.5H7v-1z" )
                #   path( d: "M4.5 6A1.5 1.5 0 003 7.5v9A1.5 1.5 0 004.5 18h7a1.5 1.5 0 001.5-1.5v-5.879a1.5 1.5 0 00-.44-1.06L9.44 6.439A1.5 1.5 0 008.378 6H4.5z" )
                # end
                span {"Search"}
              end
            end
            div( class: "py-1", role: "none") do
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-1") do
                svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                  path( d: "M7 3.5A1.5 1.5 0 018.5 2h3.879a1.5 1.5 0 011.06.44l3.122 3.12A1.5 1.5 0 0117 6.622V12.5a1.5 1.5 0 01-1.5 1.5h-1v-3.379a3 3 0 00-.879-2.121L10.5 5.379A3 3 0 008.379 4.5H7v-1z" )
                  path( d: "M4.5 6A1.5 1.5 0 003 7.5v9A1.5 1.5 0 004.5 18h7a1.5 1.5 0 001.5-1.5v-5.879a1.5 1.5 0 00-.44-1.06L9.44 6.439A1.5 1.5 0 008.378 6H4.5z" )
                end
                span {"Duplicate"}
              end
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-2") do
                svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                  path( d: "M2 3a1 1 0 00-1 1v1a1 1 0 001 1h16a1 1 0 001-1V4a1 1 0 00-1-1H2z" )
                  path( fill_rule: "evenodd", d: "M2 7.5h16l-.811 7.71a2 2 0 01-1.99 1.79H4.802a2 2 0 01-1.99-1.79L2 7.5zM7 11a1 1 0 011-1h4a1 1 0 110 2H8a1 1 0 01-1-1z", clip_rule: "evenodd" )
                end
                span {"Archive"}
              end
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-3") do
                svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                  path( fill_rule: "evenodd", d: "M10 18a8 8 0 100-16 8 8 0 000 16zM6.75 9.25a.75.75 0 000 1.5h4.59l-2.1 1.95a.75.75 0 001.02 1.1l3.5-3.25a.75.75 0 000-1.1l-3.5-3.25a.75.75 0 10-1.02 1.1l2.1 1.95H6.75z", clip_rule: "evenodd" )
                end
                span {"Move"}
              end
            end
            div( class: "py-1", role: "none") do
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-4") do
                svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                  path( d: "M11 5a3 3 0 11-6 0 3 3 0 016 0zM2.615 16.428a1.224 1.224 0 01-.569-1.175 6.002 6.002 0 0111.908 0c.058.467-.172.92-.57 1.174A9.953 9.953 0 018 18a9.953 9.953 0 01-5.385-1.572zM16.25 5.75a.75.75 0 00-1.5 0v2h-2a.75.75 0 000 1.5h2v2a.75.75 0 001.5 0v-2h2a.75.75 0 000-1.5h-2v-2z" )
                end
                span {"Share"}
              end
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-5") do
                svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                  path( d: "M9.653 16.915l-.005-.003-.019-.01a20.759 20.759 0 01-1.162-.682 22.045 22.045 0 01-2.582-1.9C4.045 12.733 2 10.352 2 7.5a4.5 4.5 0 018-2.828A4.5 4.5 0 0118 7.5c0 2.852-2.044 5.233-3.885 6.82a22.049 22.049 0 01-3.744 2.582l-.019.01-.005.003h-.002a.739.739 0 01-.69.001l-.002-.001z" )
                end
                span {"Add to favorites"}
              end
            end
            div( class: "py-1", role: "none") do
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-6") do
                svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                  path( fill_rule: "evenodd", d: "M8.75 1A2.75 2.75 0 006 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 10.23 1.482l.149-.022.841 10.518A2.75 2.75 0 007.596 19h4.807a2.75 2.75 0 002.742-2.53l.841-10.52.149.023a.75.75 0 00.23-1.482A41.03 41.03 0 0014 4.193V3.75A2.75 2.75 0 0011.25 1h-2.5zM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4zM8.58 7.72a.75.75 0 00-1.5.06l.3 7.5a.75.75 0 101.5-.06l-.3-7.5zm4.34.06a.75.75 0 10-1.5-.06l-.3 7.5a.75.75 0 101.5.06l.3-7.5z", clip_rule: "evenodd" )
                end
                span {"Delete"}
              end
            end
            div( class: "py-1", role: "none") do
              a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-6") do
                span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"architecture"}
                # svg( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do
                #   path( fill_rule: "evenodd", d: "M8.75 1A2.75 2.75 0 006 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 10.23 1.482l.149-.022.841 10.518A2.75 2.75 0 007.596 19h4.807a2.75 2.75 0 002.742-2.53l.841-10.52.149.023a.75.75 0 00.23-1.482A41.03 41.03 0 0014 4.193V3.75A2.75 2.75 0 0011.25 1h-2.5zM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4zM8.58 7.72a.75.75 0 00-1.5.06l.3 7.5a.75.75 0 101.5-.06l-.3-7.5zm4.34.06a.75.75 0 10-1.5-.06l-.3 7.5a.75.75 0 101.5.06l.3-7.5z", clip_rule: "evenodd" )
                # end
                span {"Design"}
              end
            end
          end
        end
      end
    end
  end
end
