module FlexibleEnum
  class ConstantConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      elements.each do |element_name, element_config|
        constant_name  = element_name.to_s.upcase
        constant_value = element_config[:value]
        module_for_elements.const_set(constant_name, constant_value)
      end
    end
  end
end
