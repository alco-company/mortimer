module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::Form < Phlex::HTML
    include Phlex::Rails::Helpers::FormWith

    def initialize( resource: nil, css: "" )
      @resource = resource
      @classes = "h-full flex flex-col bg-white shadow-xl overflow-y-scroll #{@css}"
    end

    def template(&)
      form_with( model: @resource, 
        url: helpers.resource_url(), 
        id: helpers.resource_form, 
        enctype: "multipart/form-data",
        data: { form_sleeve_target: 'form' }, class: @classes) do |form|
        yield(form)
      end
    end
  end
end
