module Views
  class Components::List::Row < Phlex::HTML

    def initialize( attribs: )
      @attribs = attribs
    end

    def template(&)
      # render Layout.new(title: "Index Column") do
      tr( **@attribs, &)
      # end
    end
  end
end
