module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::HiddenField < Phlex::HTML
    include Phlex::Rails::Helpers::HiddenField

    def initialize( field, **attribs )
      @resource = attribs[:resource]
      @field = field
      @assoc = attribs[:assoc] || nil
      @obj = @assoc.nil? ? @resource : @resource.send(@assoc)
      @field_value = attribs[:value] || @obj.send(@field)
      @field_name = attribs[:name] || ( @assoc.nil? ? "#{@resource.class.to_s.underscore}[#{@field}]" : "#{@resource.class.to_s.underscore}[#{@assoc}_attributes][#{@field}]" )
    end

    def template()
      hidden_field( @resource, @field, 
        name: @field_name,
        value: @field_value)
    end
  end
end
