module ViewComponentsHelper

  def render_component(component_path, collection: nil, **options, &block)
    component_klass = "#{component_path.classify}Component".constantize

    if collection
      render component_klass.with_collection(collection, **options), &block
    else
      render component_klass.new(**options), &block
    end
  end

  def render_header(**attribs, &block)
    if attribs[:sort]
      attribs[:label] = raw sort_link_to( attribs[:label], attribs[:column], data: { turbo_action: "advance"})
    end
    render Views::Components::List::Header.new **attribs, &block
  end

  # Lists
  def render_row(attribs: {}, &block)
    render Views::Components::List::Row.new attribs:, &block
  end

  def render_column(css: "", content:)
    render Views::Components::List::Column.new css:, content:
  end

  # Tabs
  def render_tab(**attribs, &block)
    render Views::Components::Show::Tab.new **attribs, &block
  end

  def render_tab_header(**attribs, &block)
    render Views::Components::Show::TabHeader.new **attribs, &block
  end

  # Dictionaries
  def render_dictionary(**attribs, &block)
    render Views::Components::Show::Dictionary.new **attribs, &block
  end

  def render_dictionary_item(**attribs, &block)
    render Views::Components::Show::DictionaryItem.new **attribs, &block
  end

  # Show
  def render_show(**attribs, &block)
    render Views::Components::Show::Show.new **attribs, &block
  end
  
  def render_show_header(**attribs, &block)
    render Views::Components::Show::ShowHeader.new **attribs, &block
  end

  # PunchClock 
  def render_punch_clock_buttons(employee)
    render Views::Components::PunchClock::Buttons.new employee_id: employee.id, state: employee.state
  end

end