module Views
  class Index::Column < Phlex::HTML

    def initialize( content: "", css: "" )
      @classes = css
      @content = content
    end

    def template(&)
      # render Layout.new(title: "Index Column") do
      td class: "#{@classes} px-6 py-4 whitespace-nowrap text-sm text-gray-500" do
        @content
      end
      # end
    end
  end
end
