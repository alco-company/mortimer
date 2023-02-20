module Views
  class Components::List::Column < Phlex::HTML

    def initialize( content: "", css: "" )
      @classes = css
      @content = content
    end

    def template(&)
      # render Layout.new(title: "Index Column") do
      td class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 #{@classes} " do
        @content
      end
      # end
    end
  end
end
