json.array! @resources, partial: "#{ resource_class.to_s.pluralize.underscore }/#{resource_class.to_s.underscore}", as: resource_class.to_s.underscore.to_sym
