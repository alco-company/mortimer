# frozen_string_literal: true

class Resource::ComboComponent < ViewComponent::Base

  renders_one :header
  renders_one :footer

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

    #
    def initialize( form:, attr:, label: nil, type: :single, focus: false, url: nil, partial: nil, lookup_target: nil, values: nil, items: nil, api_key: nil, api_class: nil )
      @form = form
      @attr = attr
      @label = label || t(attr)
      @type = type 
      @url = url || ""
      @partial = partial || @url
      @focus = focus
      @lookup_target = lookup_target || "#{@url.underscore}".gsub('/','')       # '/locations' -> 'locations'
      @values = values 
      @values ||= values_for attr
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
      
    end

    def values_for attr 
      obj = @form.object.nil? ? @form.resource : @form.object
      obj.send("combo_values_for_#{attr}") || []
    end

end
