module Views
  #
  # the errors component wraps the error messages
  #
  class Components::Form::Errors < Phlex::HTML

    def initialize( resource: nil )
      @size = resource.errors.size 
      @msg = resource.errors.full_messages.join(",")
    end

    def template(&)

      div( data: { form_sleeve_target: "errors" }, class: "py-6 space-y-6 sm:py-0 sm:space-y-0 sm:divide-y sm:divide-red-200 bg-red-200" ) do
        div( class: "error_container space-y-1 px-4 sm:space-y-0 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 sm:py-5") do
          div( class: "text-sm text-red-800") do 
            @size
            br
            p( class: "all_errors") { @msg }
          end
        end
      end
      
    end
  end
end
