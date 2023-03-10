module Views
  class Components::List::Column < Phlex::HTML

    def initialize( **attribs )
      @classes = attribs[:css]
      @content = attribs[:content]
      @type = attribs[:type] || nil
      @attribs = attribs
    end

    def template(&)
      td( class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 #{@classes} ") do
        edit_column
      end
    end

    def edit_column()
      case @type
      when 'edit'; render Views::Components::List::EditColumn.new( **@attribs)
      else; @content
      end
    end
  end
end
