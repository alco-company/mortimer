# @markup markdown
#
# The Views::Components::List::SearchFilter class is a component that renders the list search and filter view part.
#
# @example
#   <%= render Views::Components::List::SearchFilter.new %>
#
# @see Views::Components::List::SearchFilter#template
#
#
module Views
  class Components::List::SearchFilter < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize()
    end

    def template()
      div(id: "searchpane", class:" bg-white", data_controller: "search", data_search_target:"filterwrapper",  data_search_change_class: 'hidden') do

        #<!-- Filters -->
        section( aria_labelledby:"filter-heading", class:"grid items-center border-t border-b border-gray-200") do
          h2( id:"filter-heading", class:"sr-only") {"Search, Filters and Sort"}
          div(class:"relative col-start-1 row-start-1 py-4") do
            div(class:"mx-auto flex max-w-7xl justify-end px-4 sm:px-6 lg:px-8") do
              div(class:"relative inline-block") do
                div(class:"flex") do
                  form( class:"w-full flex md:ml-0", action:"#", method:"GET" ) do
                    label( for:"search", class:"sr-only") do
                      span( class:"translation_missing", title:"translation missing: da.search") {"Search"}
                    end
                    div( class:"ml-2 mt-1 relative rounded-md shadow-sm" ) do
                      div( class:"absolute inset-y-0 left-1 flex items-center text-gray-500 pointer-events-none", aria_hidden:"true" ) do
                        # <!-- Heroicon name: solid/search -->
                        svg( class:"h-5 w-5", xmlns:"http://www.w3.org/2000/svg", viewBox:"0 0 20 20", fill:"currentColor", aria_hidden:"true" ) do
                          path( fill_rule:"evenodd", d:"M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z", clip_rule:"evenodd" )
                        end
                      end
                      input( class:"block w-full h-full pl-8 pr-3 py-2 rounded-md border-transparent text-gray-900 placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-0 focus:border-transparent sm:text-sm", placeholder:"Søg...", type:"search", name:"search" )
                    end
                  end                  
                end
              end
            end
          end
          div(class:"relative col-start-1 row-start-1 py-4") do
            div(class:"mx-auto flex max-w-7xl space-x-6 divide-x divide-gray-200 px-4 text-sm sm:px-6 lg:px-8") do
              div do
                button( type:"button", class:"group flex items-center font-medium text-gray-700", aria_controls:"disclosure-1", aria_expanded:"false") do
                  svg( class:"mr-2 h-5 w-5 flex-none text-gray-400 group-hover:text-gray-500", aria_hidden:"true", viewBox:"0 0 20 20", fill:"currentColor") do
                    path( fill_rule:"evenodd", d:"M2.628 1.601C5.028 1.206 7.49 1 10 1s4.973.206 7.372.601a.75.75 0 01.628.74v2.288a2.25 2.25 0 01-.659 1.59l-4.682 4.683a2.25 2.25 0 00-.659 1.59v3.037c0 .684-.31 1.33-.844 1.757l-1.937 1.55A.75.75 0 018 18.25v-5.757a2.25 2.25 0 00-.659-1.591L2.659 6.22A2.25 2.25 0 012 4.629V2.34a.75.75 0 01.628-.74z", clip_rule:"evenodd")
                  end
                  text "2 Filters"
                end
              end
              div(class:"pl-6") do
                button( type:"button", class:"text-gray-500") {"Clear all"}
              end
            end
          end
          div(class:"hidden border-t border-gray-200 py-10", id:"disclosure-1") do
            div(class:"mx-auto grid max-w-7xl grid-cols-2 gap-x-4 px-4 text-sm sm:px-6 md:gap-x-6 lg:px-8") do
              div(class:"grid auto-rows-min grid-cols-1 gap-y-10 md:grid-cols-2 md:gap-x-6") do
                fieldset do
                  legend( class:"block font-medium") {"Price"}
                  div(class:"space-y-6 pt-6 sm:space-y-4 sm:pt-4") do
                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"price-0", name:"price[]", value:"0", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"price-0", class:"ml-3 min-w-0 flex-1 text-gray-600") {"$0 - $25"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"price-1", name:"price[]", value:"25", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"price-1", class:"ml-3 min-w-0 flex-1 text-gray-600") {"$25 - $50"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"price-2", name:"price[]", value:"50", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"price-2", class:"ml-3 min-w-0 flex-1 text-gray-600") {"$50 - $75"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"price-3", name:"price[]", value:"75", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"price-3", class:"ml-3 min-w-0 flex-1 text-gray-600") {"$75+"}
                    end
                  end
                end
                fieldset do
                  legend( class:"block font-medium") {"Color"}
                  div(class:"space-y-6 pt-6 sm:space-y-4 sm:pt-4") do
                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"color-0", name:"color[]", value:"white", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"color-0", class:"ml-3 min-w-0 flex-1 text-gray-600") {"White"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"color-1", name:"color[]", value:"beige", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"color-1", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Beige"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"color-2", name:"color[]", value:"blue", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500", checked: true)
                      label( for:"color-2", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Blue"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"color-3", name:"color[]", value:"brown", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"color-3", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Brown"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"color-4", name:"color[]", value:"green", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"color-4", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Green"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"color-5", name:"color[]", value:"purple", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"color-5", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Purple"}
                    end
                  end
                end
              end
              div(class:"grid auto-rows-min grid-cols-1 gap-y-10 md:grid-cols-2 md:gap-x-6") do
                fieldset do
                  legend( class:"block font-medium") {"Size"}
                  div(class:"space-y-6 pt-6 sm:space-y-4 sm:pt-4") do
                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"size-0", name:"size[]", value:"xs", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"size-0", class:"ml-3 min-w-0 flex-1 text-gray-600") {"XS"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"size-1", name:"size[]", value:"s", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500", checked: true)
                      label( for:"size-1", class:"ml-3 min-w-0 flex-1 text-gray-600") {"S"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"size-2", name:"size[]", value:"m", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"size-2", class:"ml-3 min-w-0 flex-1 text-gray-600") {"M"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"size-3", name:"size[]", value:"l", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"size-3", class:"ml-3 min-w-0 flex-1 text-gray-600") {"L"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"size-4", name:"size[]", value:"xl", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"size-4", class:"ml-3 min-w-0 flex-1 text-gray-600") {"XL"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"size-5", name:"size[]", value:"2xl", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"size-5", class:"ml-3 min-w-0 flex-1 text-gray-600") {"2XL"}
                    end
                  end
                end
                fieldset do
                  legend( class:"block font-medium") {"Category"}
                  div(class:"space-y-6 pt-6 sm:space-y-4 sm:pt-4") do
                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"category-0", name:"category[]", value:"all-new-arrivals", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"category-0", class:"ml-3 min-w-0 flex-1 text-gray-600") {"All New Arrivals"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"category-1", name:"category[]", value:"tees", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"category-1", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Tees"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"category-2", name:"category[]", value:"objects", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"category-2", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Objects"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"category-3", name:"category[]", value:"sweatshirts", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"category-3", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Sweatshirts"}
                    end

                    div(class:"flex items-center text-base sm:text-sm") do
                      input(id:"category-4", name:"category[]", value:"pants-and-shorts", type:"checkbox", class:"h-4 w-4 flex-shrink-0 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500")
                      label( for:"category-4", class:"ml-3 min-w-0 flex-1 text-gray-600") {"Pants &amp; Shorts"}
                    end
                  end
                end
              end
            end
          end
          div(class:"col-start-1 row-start-1 py-4") do
            div(class:"mx-auto flex max-w-7xl justify-end px-4 sm:px-6 lg:px-8") do
              div(class:"relative inline-block") do
                div(class:"flex") do
                  button( type:"button", class:"group inline-flex justify-center text-sm font-medium text-gray-700 hover:text-gray-900", id:"menu-button", aria_expanded:"false", aria_haspopup:"true") do
                    text "Sortér efter"
                    svg( class:"-mr-1 ml-1 h-5 w-5 flex-shrink-0 text-gray-400 group-hover:text-gray-500", viewBox:"0 0 20 20", fill:"currentColor", aria_hidden:"true") do
                      path( fill_rule:"evenodd", d:"M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z", clip_rule:"evenodd")
                    end
                  end
                end

                #<!--
                #  Dropdown menu, show/hide based on menu state.
                #
                #  Entering: "transition ease-out duration-100"
                #    From: "transform opacity-0 scale-95"
                #    To: "transform opacity-100 scale-100"
                #  Leaving: "transition ease-in duration-75"
                #    From: "transform opacity-100 scale-100"
                #    To: "transform opacity-0 scale-95"
                #-->
                #div(class:"absolute right-0 z-10 mt-2 w-40 origin-top-right rounded-md bg-white shadow-2xl ring-1 ring-black ring-opacity-5 focus:outline-none" role:"menu" aria_orientation:"vertical" aria_labelledby:"menu-button", tabindex:"-1") do
                #  div(class:"py-1", role:"none") do
                #    <!--
                #      Active: "bg-gray-100", Not Active: ""
                #
                #      Selected: "font-medium text-gray-900", Not Selected: "text-gray-500"
                #    -->
                #    a( href:"#" class:"font-medium text-gray-900 block px-4 py-2 text-sm" role:"menuitem" tabindex:"-1", id:"menu-item-0") {"Most Popular"}
                #
                #    a( href:"#" class:"text-gray-500 block px-4 py-2 text-sm" role:"menuitem" tabindex:"-1", id:"menu-item-1") {"Best Rating"}
                #
                #    a( href:"#" class:"text-gray-500 block px-4 py-2 text-sm" role:"menuitem" tabindex:"-1", id:"menu-item-2") {"Newest"}
                #  end
                #end
              end
            end
          end
        end
      end      
    end
  end
end
