# frozen_string_literal: true

class Resource::ComboComponent < ViewComponent::Base

  renders_one :header
  renders_one :footer

    #
    # form*           - the form element 
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
    #                   so an few example types would be: single_list, multi_drop, 
    #                   multi_tags, single_drop_search, multi_list_search_add
    #
    # url             - this is the URL which will support a 'lookup' method/action
    # partial         - if different from '/#{url}/lookup' (but the /lookup part is fixed in combo_component.html.erb)
    # lookup_target   - if different from '#{url}' - where to list elements on lookup
    # values          - if different from attr
    # items           - if different from '/#{url}/lookup?q=*'
    #
    # usage:          in your form you'll do something like
    #                 form:, attr:, label: nil, type: :simple, url: nil, partial: nil, lookup_target: nil, values: nil, items: nil 
    #                 form: form, attr: :roles, label: t('.roles'), type: :single_list, url: "/roles", partial: "/roles", values: resource.participantable.roles, items: Role.all
    # 
    #                 <!-- roles -->
    #                 render_component "resource/combo", form: form, attr: :roles, label: t('.roles'), type: :multi_list, url: "/roles", items: Role.all
    #
    def initialize( form:, attr:, label: nil, type: :simple, focus: false, url: nil, partial: nil, lookup_target: nil, values: nil, items: nil )
      @form = form
      @attr = attr
      @label = label || t(attr)
      @type = type 
      @url = url || ""
      @partial = partial || @url
      @focus = focus
      @lookup_target = lookup_target || "#{@url.underscore}".gsub('/','')
      @values = values 
      @values ||= @form.object.send("combo_values_for_#{attr}") 
      @items = items || []
 
      type_s = type.to_s
      @is_single  = !(type_s =~ /single/).nil?
      @is_multi   = !@is_single
      @is_drop   = !(type_s =~ /drop/).nil?
      @is_list   = !(type_s =~ /list/).nil?
      @is_tags   = !(type_s =~ /tag/).nil?
      @is_search = !(type_s =~ /search/).nil?
      @is_add    = !(type_s =~ /add/).nil?
      
    end

end
