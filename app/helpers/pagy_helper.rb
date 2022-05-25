
require 'pagy/i18n'

#
# TODO This will break if/when Pagy gem is updated/upgraded !!!
# 02/02/2022 - Walther H Diechmann
#
module PagyHelper

  #
  # include Pagy::Frontend
  #
  # See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/api/frontend

  PAGE_PLACEHOLDER  = '__pagy_page__'
  LABEL_PLACEHOLDER = '__pagy_label__'

  # Generic pagination: it returns the html with the series of links to the pages
  def pagy_nav(pagy, pagy_id: nil, link_extra: '', **vars)
    return '' unless pagy
    p_id   = %( id="#{pagy_id}") if pagy_id
    link   = pagy_link_proc(pagy, link_extra: link_extra)
    p_prev = pagy.prev
    p_next = pagy.next

    html = +%(<nav#{p_id} class=" border-gray-200 px-4 flex items-center justify-between sm:px-0" aria-label="pager">)
    html << %(<div class="-mt-px w-0 flex-1 flex">)
                
    if p_prev
      html << %(#{link.call p_prev, txt_svg, 'aria-label="previous" data-turbo-action="advance" class="border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300"'}) 
      html << %(</a>)
    else
      html << %(<span class="border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300">#{pagy_t('pagy.nav.prev')}</span> )
    end
    html << %(</div>)
    html << %(<div class="hidden md:-mt-px md:flex">)
    pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
      when Integer then %(#{link.call item, pagy.label_for(item),' data-turbo-action="advance" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 border-t-2 pt-4 px-4 inline-flex items-center text-sm font-medium"'}</a> )
      when String  then %(<a href="#" class="border-indigo-500 text-indigo-600 border-t-2 pt-4 px-4 inline-flex items-center text-sm font-medium" aria-current="page">#{pagy.label_for(item)}</a> )
      when :gap    then %(<span class="border-transparent text-gray-500 border-t-2 pt-4 px-4 inline-flex items-center text-sm font-medium">#{pagy_t('pagy.nav.gap')}</span> )
      else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
      end
    end
    html << %(</div>)
    html << %(<div class="-mt-px w-0 flex-1 flex justify-end">)
    if p_next
      html << %(#{link.call p_next, pagy_t('pagy.nav.next'),'aria-label="next"  data-turbo-action="advance" class="border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300"'})
      html << %(<svg class="ml-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">)
      html << %(<path fill-rule="evenodd" d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />)
      html << %(</svg>)
      html << %(</a>)
    else
      html << %(<span class="border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300"">#{pagy_t('pagy.nav.next')}</span>)
    end
    html << %(</div>)
    html << %(</nav>)
  end

  def txt_svg 
    
    html = +%(<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">)
    html << %(<path fill-rule="evenodd" d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />)
    html << %(</svg>)
    html << %(#{pagy_t('pagy.nav.prev')})
    html
  end

  # Return examples: "Displaying items 41-60 of 324 in total" or "Displaying Products 41-60 of 324 in total"
  def pagy_info(pagy, pagy_id: nil, item_name: nil, i18n_key: nil )
    return '' unless pagy
    p_id    = %( id="#{pagy_id}") if pagy_id
    p_items = pagy.to - pagy.from + 1
    p_count = pagy.count
    key     = if    p_count.zero?   then 'pagy.info.no_items'
              elsif pagy.pages == 1 then 'pagy.info.single_page'
              else                       'pagy.info.multiple_pages' # rubocop:disable Lint/ElseLayout
              end
    info = pagy_t key, item_name: item_name || t(i18n_key || pagy.vars[:i18n_key], count: p_items),
    count: p_count, from: pagy.from, to: pagy.to, items: p_items 

    %(<div#{p_id} class="relative flex justify-center mt-2 -top-2 h-4 ">#{ make_size_selectable info }</div>)
  end
  
  def make_size_selectable info
    %(<div class="absolute text-center collapse-menu-anchor mx-auto h-40 w-72 px-2 pt-1 text-sm text-gray-500 bg-slate-50 shadow-lg rounded-md"> #{ raw info }#{ raw render_pagesize }</div>)
  end

  def render_pagesize
    %(
      <div class="collapse-menu grid grid-flow-row-dense grid-cols-3 grid-rows-3 z-10 mt-1 mb-2 pt-4 pb-4 text-base sm:text-sm" 
        tabindex="-1" >
        <div class="h-10">#{ nbr_link_to 10 }</div>
        <div class="h-10">#{ nbr_link_to 15 }</div>
        <div class="h-10">#{ nbr_link_to 25 }</div>
        <div class="h-10">#{ nbr_link_to 30 }</div>
        <div class="h-10">#{ nbr_link_to 50 }</div>
        <div class="h-10">#{ nbr_link_to 100 }</div>
      </div>
    )
  end

  def nbr_link_to n 
    link_to n, request.params.merge(items: n)
  end

  # Return a performance optimized proc to generate the HTML links
  # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
  def pagy_link_proc(pagy, link_extra: '')
    return '' unless pagy
    p_prev      = pagy.prev
    p_next      = pagy.next
    left, right = %(<a href="#{pagy_url_for(pagy, PAGE_PLACEHOLDER, html_escaped: true)}" #{
                      pagy.vars[:link_extra]} #{link_extra}).split(PAGE_PLACEHOLDER, 2)
    lambda do |page, text = pagy.label_for(page), extra_attrs = ''|
      %(#{left}#{page}#{right}#{ case page
                                when p_prev then ' rel="prev"'
                                when p_next then ' rel="next"'
                                else             ''
                                end } #{extra_attrs}>#{text})
    end
  end

  # Similar to I18n.t: just ~18x faster using ~10x less memory
  # (@pagy_locale explicitly initialized in order to avoid warning)
  def pagy_t(key, opts = {})
    Pagy::I18n.translate(@pagy_locale ||= nil, key, opts)
  end

  # frozen_string_literal: true
  # Return the URL for the page, relying on the params method and Rack by default.
  # It supports all Rack-based frameworks (Sinatra, Padrino, Rails, ...).
  # For non-rack environments you can use the standalone extra
  def pagy_url_for(pagy, page, absolute: false, html_escaped: false)
    vars                = pagy.vars
    page_param          = vars[:page_param].to_s
    items_param         = vars[:items_param].to_s
    params              = pagy.params.is_a?(Hash) ? pagy.params.transform_keys(&:to_s) : {}
    params              = request.GET.merge(params)
    params[page_param]  = page
    params[items_param] = vars[:items] if vars[:items_extra]
    query_string        = "?#{Rack::Utils.build_nested_query(pagy_deprecated_params(pagy, params))}"  # remove in 6.0
    # params              = pagy.params.call(params) if pagy.params.is_a?(Proc)                       # add in 6.0
    # query_string        = "?#{Rack::Utils.build_nested_query(params)}"                              # add in 6.0
    query_string        = query_string.gsub('&', '&amp;') if html_escaped  # the only unescaped entity
    "#{request.base_url if absolute}#{request.path}#{query_string}#{vars[:fragment]}"
  end

  private

    # Transitional code to handle params deprecations. It will be removed in version 6.0
    def pagy_deprecated_params(pagy, params)    # remove in 6.0
      if pagy.params.is_a?(Proc)                # new code
        pagy.params.call(params)
      elsif respond_to?(:pagy_massage_params)   # deprecated code
        Warning.warn '[PAGY WARNING] The pagy_massage_params method has been deprecated and it will be ignored from version 6. ' \
                     'Set the :params variable to a Proc with the same code as the pagy_massage_params method.'
        pagy_massage_params(params)
      else
        params                                  # no massage params
      end
    end

end





