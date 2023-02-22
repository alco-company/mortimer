module ApplicationHelper
  def say(msg)
    return unless Rails.env.development?

    Rails.logger.info msg
  end

  # instead of adding _html to the i18n keys
  # we just do the same thing really
  def raw_t(msg)
    raw t(msg)
  end

  def record_state(rec)
    raw_t(rec.state)
  rescue StandardError
    'N/A'
  end

  def display_time(dt, user)
    return '' if dt.blank?

    I18n.localize dt.in_time_zone(user.time_zone), format: :long
  rescue StandardError
    Rails.logger.warn "user #{user}, dt #{dt}"
    if user
      raw "<span class='hidden'>dt is empty or not a date nor a (date)time</span>"
    else
      raw "#{dt}<span class='hidden'>user empty or not a User</span>"
    end
  end

  def display_date(dt, user)
    return '' if dt.blank?

    I18n.localize dt.in_time_zone(user.time_zone), format: :date
  rescue StandardError
    raw "<span class='hidden'>dt is empty or not a date nor a (date)time</span>"
  end

  # location is "lat,long,text"
  def display_geo_tab(location)
    geo = begin
      location.split(',')[0..1]
    rescue StandardError
      nil
    end
    return '' if geo.nil? or (geo[0] == 0 and geo[1] == 0)

    link_to "https://www.openstreetmap.org/search?query=#{geo[0]}%2C#{geo[1]}#map=14", target: '_blank' do
      raw %(
        #{geo.join(', ')}
        <span class="material-symbols-outlined">
        open_in_new
      </span>)
    end
  end

  def display_punch_clock(resource)
    return t('app_punch_clock_used') if resource.punch_asset.assetable_type == 'Employee'

    link_to resource.punch_asset.name, punch_clock_url(resource.punch_asset.assetable)
  end

  def tailwind_classes_for(flash_type)
    {
      notice: 'bg-green-400 border-l-4 border-green-700 text-white',
      warning: 'bg-yellow-300 border-l-4 border-yellow-500 text-amber-600',
      alert: 'bg-yellow-300 border-l-4 border-yellow-500 text-amber-600',
      error: 'bg-red-400 border-l-4 border-red-700 text-red-700'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def table_header_checkbox
    raw %(<div class="relative flex table-cell">
      <input
      id="toggle-all-rows"
      name="color[]"
      value="white"
      type="checkbox"
      data-action="click->list-item-actions#tap keydown->list-item-actions#keydownHandler speicherMessage@window->list-item-actions#handleMessages "
      class="h-4 w-4 mr-4 border-gray-300 rounded text-indigo-600 focus:ring-indigo-500">
    </div>)
  end

  def table_row_checkbox(rec = nil)
    raw %(<div class="table-cell" >
      <input id="#{begin
        dom_id rec
      rescue StandardError
        rand(12_341_234)
      end}_check"
        name="row_selected[]"
        value="white"
        type="checkbox"
        data-action="click->list-item#tap"
        class="h-4 w-4 mr-4 border-slate-300 rounded text-slate-600 focus:ring-slate-500">
    </div>)
  end

  def sort_link_to lbl, column, **options
    direction = if params[:s] == column.to_s
                  params[:d] == 'asc' ? 'desc' : 'asc'
                else
                  'asc'
                end
    link_to lbl, request.params.merge(s: column, d: direction), **options
  end

  def more_records?
    return unless @pagy.nil? or (begin
      (params[:page].to_i + 1)
    rescue StandardError
      1
    end > @pagy.pages)

    raw %(
        <tr class="hidden" data-pagination-target="noRecords"><td>no more records</td></tr>
      )
  end

  def form_header_title
    params[:action] == 'new' ? raw_t('.new') : raw_t('.edit')
  end

  def form_header_description
    params[:action] == 'new' ? raw_t('.new_description') : raw_t('.edit_description')
  end

  def show_account_logo(current_user)
    original = %(
      <img class="h-8 w-auto" src="https://tailwindui.com/img/logos/workflow-logo-indigo-300-mark-white-text.svg" alt="Workflow">
    )

    unless current_user.nil?
      # raw image_tag "logo-rgb.png", class: "block h-8 w-auto"
    end
    raw %(
        <span class="sr-only">Open sidebar</span>
          <!-- Heroicon name: outline/menu-alt-2 -->
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
          </svg>
      )
  end

  def enumerate_hours(start, stop)
    enumerate_datetime(start, stop, 1.hour)
  end

  def enumerate_days(start, stop)
    enumerate_datetime(start, stop, 1.day)
  end

  def enumerate_datetime(start, stop, gap)
    Enumerator.new do |y|
      loop do
        y.yield start
        start += gap
      end
    end.take_while { |d| d < stop }
  end
end
