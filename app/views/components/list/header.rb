# @markup markdown
#
# The Views::Components::List::Header class is a component that renders a table header.
#
# One typical use case is to render a table header with a label and a sort link.
# That looks like this: `<%= render_header sort: true, label: t('.name'), column: :name %>`
#
# Most lists have a checkbox column. That looks like this: `<%= render_header column: 'checkbox', css: 'hidden' %>`
#
# The edit column is a special case. It looks like this: `<%= render_header column: 'more' %>` and offers the user
# a link to edit the record.
#
module Views
  class Components::List::Header < Phlex::HTML

    def initialize( **attribs, &block )
      @label = attribs[:label] || ""
      @column = attribs[:column] || ''
      @css = attribs[:css] || ""
      @url = attribs[:url] || '' 
      @sort = attribs[:sort] || false
      @column = attribs[:column] || ''
      @classes = "sm:table-cell px-6 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider #{@css} "
    end

    def template(&)
      column_content
      th scope: "col", class: @classes do
        @content
      end
    end

    def column_content
      case @column
      when 'checkbox'; @content = table_header_checkbox
      when 'edit'; @content, @classes = ['<span class="sr-only">Edit</span>'.html_safe, 'relative px-6 py-3']
      when 'more'; @content = table_header_more
      else
        @content = @label
      end
    end

    def table_header_checkbox
      %(<div class="relative flex table-cell">
        <input
        id="toggle-all-rows"
        name="color[]"
        value="white"
        type="checkbox"
        data-action="click->list-item-actions#tap keydown->list-item-actions#keydownHandler speicherMessage@window->list-item-actions#handleMessages "
        class="h-4 w-4 mr-4 border-gray-300 rounded text-indigo-600 focus:ring-indigo-500">
      </div>).html_safe
    end

    def table_header_more
      helpers.render_search_and_more_button classes: "z-20 text-left flex float-right"
      #render Views::Components::SearchAndMoreButton.new"
    end

  end
end
