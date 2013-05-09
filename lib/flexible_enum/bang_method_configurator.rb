module FlexibleEnum
  class BangMethodConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      elements.each do |element_name, element_config|
        class_for_attribute.instance_eval do
          bang_method_name = element_config[:setter] || "#{element_name}!"
          define_method(bang_method_name) do
            update_attribute(attribute_name, element_config[:value])
          end
        end
      end
    end
  end
end
