# @markup markdown
#
# The Views::Components::List::Header class is a component that renders a table header.
#
# One typical use case is to render a table header with a label and a sort link.
# That looks like this: `<%= render_header sort: true, label: t('.name'), column: :name %>`
#
# Most lists have a checkbox column. That looks like this: `<%= render_header column: 'checkbox', css: 'hidden' %>`
#
# The edit column is a special case. It looks like this: `<%= render_header column: 'edit' %>` and offers the user
# a link to edit the record.
#
module Views
  class Components::List::Header < Phlex::HTML

    def initialize( label: "", column: '', css: "", sort: false, &block )
      @classes = "sm:table-cell px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider #{css} "
      case column
      when 'checkbox'; @content = table_header_checkbox
      when 'edit'; @content, @classes = ['<span class="sr-only">Edit</span>'.html_safe, 'relative px-6 py-3']
      else; @content = label
      end
    end

    def template(&)
      # render Layout.new(title: "Index Column") do
      th scope: "col", class: @classes do
        @content
      end
      # end
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

  end
end
