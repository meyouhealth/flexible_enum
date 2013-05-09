module FlexibleEnum
  class ScopeConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      if class_for_attribute == module_for_elements
        get_method_name = lambda {|element_name| element_name }
      else
        get_method_name = lambda {|element_name| "#{module_for_elements.to_s.split('::').last.underscore.singularize}_#{element_name}" }
      end

      class_for_attribute.class_eval do
        elements.each do |element_name, element_config|
          define_singleton_method(get_method_name.call(element_name)) do
            self.where(attribute_name => element_config[:value])
          end
        end
      end
    end
  end
end
