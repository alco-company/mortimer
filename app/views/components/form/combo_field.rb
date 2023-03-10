module Views
  #
  # the combo_field component is a wrapper for the select form input field helper
  #
  # field           - the attribute or association holding the data element
  # assoc           - the association to the data element - fx :assetable, :eventable, :participantable, more
  # title           - (translated) field title 
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
    include Phlex::Rails::Helpers::HiddenField
    include Phlex::Rails::Helpers::Label
    include Phlex::Rails::Helpers::Select
    include Phlex::Rails::Helpers::TextField


    # arguments: field, assoc: nil, title: nil, parent: nil, data: {}, required: false, focus: false, disabled: false, 
    # type: 'single_drop', url: nil, partial: nil, lookup_target: nil, lookup_label: 'name', values: nil, items: nil, api_key: nil, api_class: nil, 
    # text_css: "", label_css: "", input_css: ""
    #
    def initialize( field, **attribs, &block )
      @resource = attribs[:resource]
      @assoc = attribs[:assoc] || nil
      @obj = @assoc.nil? ? @resource : @resource.send(@assoc)
      @field = field
      @title = attribs[:title] || I18n.translate('activerecord.attributes.' + @resource.class.to_s.underscore + '.' + field.to_s)
      @description = attribs[:description] || nil
      @required = attribs[:required] || false
      @parent = attribs[:parent] || false
      @focus = attribs[:focus] || false
      @disabled = attribs[:disabled]
      @autocomplete = attribs[:autocomplete] || "off"
      @data = attribs[:data] ||  { "form-target" => "#{'focus' if @focus}" }
      @type = attribs[:type] || :single_drop
      @url = attribs[:url] || ""

      @field_value = attribs[:value] || @obj.send(@field)
      @field_name = @assoc.nil? ? "#{@resource.class.to_s.underscore}[#{@field}]" : "#{@resource.class.to_s.underscore}[#{@assoc}_attributes][#{@field}]"

      @partial = attribs[:partial] || @url
      @lookup_target = attribs[:lookup_target] || "#{@url.underscore}".gsub('/','')       # '/locations' -> 'locations'
      @values = values_for(**attribs)
      @lookup_label = attribs[:lookup_label] || 'name'
      @items = attribs[:items] || []
      @api_key = attribs[:api_key] || nil
      @api_class = attribs[:api_class] || nil
 
      type_s = @type.to_s
      @is_single  = !(type_s =~ /single/).nil?
      @is_multi   = !@is_single
      @is_drop   = !(type_s =~ /drop/).nil?
      @is_list   = !(type_s =~ /list/).nil?
      @is_tags   = !(type_s =~ /tag/).nil?
      @is_search = !(type_s =~ /search/).nil?
      @is_add    = !(type_s =~ /add/).nil?

      @list_items = []
      if @items.any?
        @items.each { |item| list_item(item,@is_add) }
      end

      @text_classes = "space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 sm:py-5 #{attribs[:text_css]}"
      @label_classes = "block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 #{attribs[:label_css]}"
      @input_classes = "block w-full shadow-sm sm:text-sm focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md #{attribs[:input_css]}}"
    end

    def template()
      if @parent
        hidden_field( @resource, @field, name: @field_name, value: @values )
      else
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
          div { label_element }
          build_form_select( @field, @items, @values, @is_multi, @lookup_label)
          div( class:"relative mt-1 col-span-2" ) do
            drop_search_add
            drop_search
            # content
            tags
            list
          end
          # div( class="relative col-span-3 text-xs" ) do
          #   <% if footer? %>
          #     <%= footer %>
          #   <% end %>
          # </div>
        end
      end
    end

    def label_element
      if @title =~ /translation missing/i
        label( @obj, @field, class: @label_classes) { span( class:"translation_missing", title: @title) { @field.to_s } }
      else
        label( @obj, @field, @title, class: @label_classes)
      end
    end

    def drop_search_add
      if ( @is_drop || @is_search || @is_add )
        input( value: combo_input_value( @values, @lookup_label.to_sym),
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
    end

    def drop_search
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
    end

    def tags
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
                class:"flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-indigo-400 hover:bg-indigo-200 hover:text-indigo-500 focus:outline-none focus:bg-indigo-500 focus:text-white"
                ) do
                span( class:"sr-only") {"Remove small option"}
                svg( class:"h-[8px] w-[8px]", stroke:"currentColor", fill:"none", viewBox:"0 0 8 8" ) do
                  path( stroke_linecap:"round", stroke_width:"1.5", d:"M1 1l6 6m0-6L1 7" )
                end
              end
            end
          end
        end
      end
    end

    def list
      div( class: "#{@is_list ? '' : 'hidden'} flex overflow-y-auto h-40 max-h-40 w-full",
        id: "#{@lookup_target}_combo_wrapper",
        data_combo_target: "selectOptions") do
        ul( id: "#{@lookup_target}_ul",
          class: "absolute h-40 max-h-40 z-10 my-1 justify-center w-full bg-white shadow-lg rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm", 
          tabindex: "-1", 
          role: "listbox", 
          aria_labelledby: "listbox-label", 
          aria_activedescendant: "listbox-option-3") do
            @list_items.each do |item|
              render(item)
            end
        end
      end    
    end

    def values_for **attribs 
      (attribs[:parent].send(:id) rescue false) || attribs[:values] || @obj.send("combo_values_for_#{@field}") || []
    end

    def build_form_select attrib, items, values, is_multi, lbl
      # if form.nil? 
      #   return hidden_field_tag( attrib, combo_input_value(values,:id), {data: { combo_target: "select"}})
      # end
      if is_multi 
        div( class: "hidden") do
          select( @resource.class.to_s.underscore.to_sym, 
            attrib, 
            helpers.options_from_collection_for_select(items,"id",lbl,{selected: ([values].flatten.any? ? [values].flatten.pluck(:id) : nil)}), 
            {},
            { multiple: true, class: "hidden", data: { combo_target: "select"}})
        end
      else
        hidden_field( @resource, attrib, 
          name: @field_name,
          value: combo_input_value(values,:id),
          data: { combo_target: "select"}
        )
      end
    end

    def combo_input_value value, key=:name 
      if [value].flatten.first.is_a? String 
        return [value].flatten.join(', ')
      end
      if [value].flatten.first.keys.include? key
        [value].flatten.pluck(key).join(', ') rescue ''
      else
        [value].flatten.join(', ')
      end
    rescue 
      ''
    end

    def list_item(item, add)
      @list_items << Item.new( @partial, @values, item, add)
    end
    
  end

  class Item < Phlex::HTML
    def initialize(par,val,item, add)
      @partial = par
      @values = val
      @item = item
      @add = add
    end
    def template(&)
      selected = (@values.pluck(:id).include?(@item.id) rescue false)
      li( class: "focus-visible:text-white focus-visible:bg-indigo-600/25 text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9",
        tabindex: "-1",
        data_action:"click->combo#clickListItem",
        data_record_id: @item.id,
        role:"option"
        ) do
        # <!-- Selected: "font-semibold", Not Selected: "font-normal" -->
        span( data_record_id: @item.id,
          data_record_name: @item.name,
          class: "#{selected ? "font_semibold" : "font_normal"} block truncate"
          ) do
          if @add && @add=="true"
            text {I18n.t('add')}
            text "&nbsp;"
          end
          @item.name
        end

        # <!--
        #   Checkmark, only display for selected option.

        #   Highlighted: "text-white", Not Highlighted: "text-indigo-600"
        # -->
        
        span( class: "#{selected ? '' : 'hidden'} text-indigo-600 absolute inset-y-0 right-0 flex items-center pr-4") do
          svg( class: "focus:text-white w-6 h-6", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" ) do
            path( stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M5 13l4 4L19 7")
          end
          # <!-- <button class: "button bg-slate-200 py-1 h-6">role</button> -->
        end
      end
    end
  end

end
