module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  #
  # form*           - the form element (or nil if no form present)
  # attr*           - the attribute or association holding the data element
  # label           - (translated) field title 
  #
  # type            - describes what features of the combo you'll be using
  #                   by really just adding keywords together using snake_case
  #
  #                   keywords =
  #
  #                   single  - meaning only one value is selectable
  #                   multi   - any number of values are selectable
  #                   drop    - make the combo 'act' like a drop down select/menu
  #                   list    - make the combo 'act' like a 'traditional' select list/menu
  #                   tags    - make the combo 'act' like an input for tags
  #                   search  - allow input to lookup values from the server
  #                   add     - allow input to be 'added' - ie create new elements like tags etc
  #   
  #                   so a few example types would be: single_list, multi_drop, 
  #                   multi_tags, single_drop_search, multi_list_search_add
  #
  # url             - this is the URL which will support a 'lookup' method/action / nil if no lookup
  # partial         - if different from '/#{url}/lookup'      (but the /lookup part is fixed in combo_component.html.erb)
  # lookup_target   - if different from '#{url}'              - where to list elements on lookup
  # values          - if different from attr                  - current value(s)
  # items           - if different from '/#{url}/lookup?q=*'  - all possible values
  # api_key         - set if component used by 'non-user'
  # api_class       - entity providing the validation to the api_key
  #
  # usage:          in your form you'll do something like
  #                 form:, attr:, label: nil, type: :simple, url: nil, partial: nil, lookup_target: nil, values: nil, items: nil 
  #                 form: form, attr: :roles, label: t('.roles'), type: :single_list, url: "/roles", partial: "/roles", values: resource.participantable.roles, items: Role.all
  # 
  #                 <!-- roles -->
  #                 render_component "resource/combo", form: form, attr: :roles, label: t('.roles'), type: :multi_list, url: "/roles", items: Role.all
  #
  #                 in your controller you'll be sure to allow the ~/lookup on searchable combo's and the ?ids= on all
  #                 (both are, however, provided by the abstract_resources_controller)
  #
  #                 on pos/controllers you'll add an api_key and an api_class to allowing the lookup and ids without being signed in
  #                    <%= render_component "resource/combo", form: nil, attr: :location, label: t('.location'), type: :single_drop, url: "/locations", values: [], items: Location.all, api_key: resource.access_token, api_class: 'Employee' %>
  #
  #                 and use it in your Stimulus controller like:
  #                    let apikey = this.apiKeyValue == '' ? '' : `&api_key=${this.apiKeyValue}&api_class=${this.apiClassValue}` 
  #                    const response = await get(`${this.urlValue}?ids=${encoded}${apikey}`, { responseKind: "json" })

  class Components::Form::ComboField < Phlex::HTML
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::TextField

    def initialize( resource: nil, form: nil, field: nil, title: nil, type: 'single_drop', 
      data: {}, required: false, focus: false, disabled: false, 
      url: nil, partial: nil, lookup_target: nil, values: nil, items: nil, api_key: nil, api_class: nil, text_css: "", label_css: "", input_css: "" )

      @resource = resource
      @form = form
      @field = field
      @title = title
      @required = required
      @focus = focus
      @disabled = disabled
      @data = data
      @type = type 
      @url = url || ""
      @partial = partial || @url
      @focus = focus
      @lookup_target = lookup_target || "#{@url.underscore}".gsub('/','')       # '/locations' -> 'locations'
      @values = values 
      @values ||= values_for field
      @items = items || []
      @api_key = api_key
      @api_class = api_class
 
      type_s = type.to_s
      @is_single  = !(type_s =~ /single/).nil?
      @is_multi   = !@is_single
      @is_drop   = !(type_s =~ /drop/).nil?
      @is_list   = !(type_s =~ /list/).nil?
      @is_tags   = !(type_s =~ /tag/).nil?
      @is_search = !(type_s =~ /search/).nil?
      @is_add    = !(type_s =~ /add/).nil?
            
      @text_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5 #{@text_css}"
      @label_classes = "block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 #{@label_css}"
      @input_classes = "block w-full shadow-sm sm:text-sm focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md #{@input_css}}"
    end

    def template()
      div( data_controller:"combo",
        data_combo_url_value: @url,
        data_combo_is_single_value: @is_single,
        data_combo_is_multi_value: @is_multi,
        data_combo_is_drop_value: @is_drop,
        data_combo_is_list_value: @is_list,
        data_combo_is_tags_value: @is_tags,
        data_combo_is_search_value: @is_search,
        data_combo_is_add_value: @is_add,
        data_combo_api_key_value: @api_key,
        data_combo_api_class_value: @api_class,
        data_combo_account_id_value: Current.account.id,
        class: "space-y-1 z-10 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5") do
        label( @resource, @field, class:"block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2" ) do
          text @title
        end
        helpers.build_form_select( @form, @field, @items, @values, @is_multi)
        div( class:"relative mt-1 col-span-2" ) do
          if ( @is_drop || @is_search || @is_add )
            input( value: helpers.combo_input_value( @values),
              placeholder:"Select value",
              autocomplete:"off",
              id:"#{@field}_combobox" ,
              type:"text" ,
              data_combo_target:"input", 
              data_form_target: (@focus ? "focus" : ""),
              data_action:"blur->combo#inOut focus->combo#inOut keydown->combo#keydownHandler keyup->combo#keyupHandler",
              class:"w-full rounded-md border border-gray-300 bg-white py-2 pl-3 pr-12 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 sm:text-sm", 
              role:"combobox", 
              aria_controls:"options",
              aria_expanded:"false")
          end
          if ( @is_drop || @is_search )
            button( type:"button",
              data_combo_target: "button",
              data_action: "click->combo#clickIcon",
              class: "absolute inset-y-0 right-0 pt-5 h-2 flex items-center rounded-r-md px-2 focus:outline-none") do
              if @is_drop && !@is_search
                # <!-- Heroicon name: solid/down -->
                svg( class:"w-5 h-5 text-gray-400", fill:"none", stroke:"currentColor", viewBox:"0 0 24 24", xmlns:"http://www.w3.org/2000/svg" ) do
                  path( stroke_linecap:"round", stroke_linejoin:"round", stroke_width:"2", d:"M19 9l-7 7-7-7" )
                end
              end
              if @is_search
                #<!-- Heroicon name: solid/selector -->
                svg( class:"h-5 w-5 text-gray-400", xmlns:"http://www.w3.org/2000/svg", viewBox:"0 0 20 20", fill:"currentColor", aria_hidden:"true" ) do
                  path( fill_rule:"evenodd", d:"M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z", clip_rule:"evenodd" )
                end
              end
            end
          end
          # content
          if @is_tags
            #<!-- here we can render one of more things: <ul> (for selects) <span> (for tags) or something entirely different -->
            div( id: "#{@lookup_target}_tags",
              data_combo_target:"tags",
              data_action:"click->combo#removeTag",
              class:"my-1") do
              @values.each do |tag|
                span( class:"inline-flex items-center py-0.5 pl-2 pr-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-700" ) do
                  text tag.name
                  button( data_id: tag.id,
                    type:"button", 
                    class:"flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-indigo-400 hover:bg-indigo-200 hover:text-indigo-500 focus:outline-none focus:bg-indigo-500 focus:text-white") do
                    span( class:"sr-only") {"Remove small option"}
                    svg( class:"h-[8px] w-[8px]", stroke:"currentColor", fill:"none", viewBox:"0 0 8 8" ) do
                      path( stroke_linecap:"round", stroke_width:"1.5", d:"M1 1l6 6m0-6L1 7" )
                    end
                  end
                end
              end
            end
          end

        div( class: "#{@is_list ? '' : 'hidden'} flex overflow-y-auto h-40 max-h-40 w-full",
            id: "#{@lookup_target}_combo_wrapper",
            data_combo_target: "selectOptions") do
            ul( id: "#{@lookup_target}_ul",
              class: "absolute h-40 max-h-40 z-10 my-1 justify-center w-full bg-white shadow-lg rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm", 
              tabindex: "-1", 
              role: "listbox", 
              aria_labelledby: "listbox-label", 
              aria_activedescendant: "listbox-option-3") do
              @items.each do |item|
                render partial: "%s/lookup" % @partial, locals: { resource: item, values: @values, form: @form }
              end
            end
          end    
        end
        # div( class="relative col-span-3 text-xs" ) do
        #   <% if footer? %>
        #     <%= footer %>
        #   <% end %>
        # </div>
      end
    end

    def values_for attr 
      obj = @form.object.nil? ? @form.resource : @form.object
      obj.send("combo_values_for_#{attr}") || []
    end
    
  end
end

# text_field field_name(:asset,:assetable_attributes), :pin_code, value: employee.object.pin_code
