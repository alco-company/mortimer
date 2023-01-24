module ComponentsHelper
  def raw_t msg
    t(msg).html_safe rescue msg
  end
 
  def search_field name:, value:, placeholder: '', component_method:
    raw %(
      <div class="pt-[2px] sm:pt-1 relative rounded-md shadow-sm">
        <input 
          type="search" 
          name="#{name.to_s}" 
          id="index_search" 
          data-search-target="input"
          data-action="keydown->#{component_method}"
          value="#{params[name]}" 
          class="focus:ring-slate-500 focus:border-slate-500 block w-full pr-10 sm:text-sm border-gray-300 rounded-md w-full" 
          placeholder="#{placeholder}">
        <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
          <!-- Heroicon name: solid/search -->
          <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"></path>
          </svg>
        </div>
      </div>
    )
  end  

  def build_form_select form, attrib, items, values, is_multi
    if form.nil? 
      return hidden_field_tag( attrib, combo_input_value(values,:id), {data: { resource__combo_component_target: "select"}})
    end
    if is_multi 
      form.select attrib, 
        options_from_collection_for_select(items,"id","name",{selected: ([values].flatten.any? ? [values].flatten.pluck(:id) : nil)}), 
        {},
        { multiple: true, class: "hidden", data: { resource__combo_component_target: "select"}}
    else
      form.hidden_field attrib, value: combo_input_value(values,:id), data: { resource__combo_component_target: "select"}
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

  def combo_select_for items, key='id', value='name'
    case items.class.to_s
    # 'key,value|key,value|...|key,value'
    when 'String'
      items.split("|").map{|i|i.split(",")}
    #[ [key,value], [key,value], ..., [key,value] ]
    when 'Array'
      items
    when /ActiveRecord/
      items.map{|i|[i.send(key),i.send(value)]}
    end
  end
end