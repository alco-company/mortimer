# @markup markdown
#
# The Views::Components::SearchAndMoreButton class is a component that renders a more button
# 
#
module Views
  class Components::SearchAndMoreButton < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize(classes: '')
      @classes = classes
    end

    def template()
      div( 
        class: @classes,
        id: "list_more_menu_component",
        data_controller: "more",
        data_more_search_outlet: "#searchpane"
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
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"add"}
              span {"Add"}
            end
            button( data_action: "click->more#toggleSearchPane", class: "cursor-pointer text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-1") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"search"}
              span {"Search"}
            end
          end
          div( class: "py-1", role: "none") do
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-1") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"content_copy"}
              span {"Duplicate"}
            end
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-2") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"archive"}
              span {"Archive"}
            end
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-3") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"place_item"}
              span {"Move"}
            end
          end
          div( class: "py-1", role: "none") do
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-4") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"share"}
              span {"Share"}
            end
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-5") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"favorite"}
              span {"Add to favorites"}
            end
          end
          div( class: "py-1", role: "none") do
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-6") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"delete"}
              span {"Delete"}
            end
          end
          div( class: "py-1", role: "none") do
            a( href: "#", class: "text-gray-700 group flex items-center px-4 py-2 text-sm", role: "menuitem", tabindex: "-1", id: "menu-item-6") do
              span( class: "mr-3 h-5 w-5 text-gray-400 group-hover:text-gray-500 material-symbols-outlined") {"architecture"}
              span {"Design"}
            end
          end
        end
      end
    end

  end
end
