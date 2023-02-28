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

  # Form
  def render_form(**attribs, &block)
    render Views::Components::Form::Form.new **attribs, &block
  end

  def render_form_header(**attribs, &block)
    render Views::Components::Form::Header.new **attribs, &block
  end

  def render_form_divider(**attribs, &block)
    render Views::Components::Form::Divider.new **attribs, &block
  end

  def render_form_action_buttons(**attribs, &block)
    render Views::Components::Form::ActionButtons.new **attribs, &block
  end

  def render_form_errors(**attribs, &block)
    render Views::Components::Form::Errors.new **attribs, &block
  end

  def render_form_fields_for(**attribs, &block)
    render Views::Components::Form::FieldsFor.new **attribs, &block
  end

  def render_form_hidden_field(**attribs, &block)
    render Views::Components::Form::HiddenField.new **attribs, &block
  end

  def render_form_text_field(**attribs, &block)
    render Views::Components::Form::TextField.new **attribs, &block
  end

  def render_form_text_area(**attribs, &block)
    render Views::Components::Form::TextArea.new **attribs, &block
  end

  def render_form_datetime_field(**attribs, &block)
    render Views::Components::Form::DateTimeField.new **attribs, &block
  end

  # Tabs
  def render_tab(**attribs, &block)
    # attribs[:title] ||= t( ".#{attribs[:field]}")
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