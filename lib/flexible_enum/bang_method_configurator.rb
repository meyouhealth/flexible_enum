module FlexibleEnum
  class BangMethodConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      elements.each do |element_name, element_config|
        class_for_attribute.instance_eval do
          bang_method_name = element_config[:setter] || "#{element_name}!"
          define_method(bang_method_name) do
            attributes = {attribute_name => element_config[:value]}
            timestamp_attribute_name = element_config[:timestamp_attribute] || element_name
            time = Time.now.utc
            attributes["#{timestamp_attribute_name}_on".to_sym] = time.to_date if class_for_attribute.attribute_method?("#{timestamp_attribute_name}_on")
            attributes["#{timestamp_attribute_name}_at".to_sym] = time if class_for_attribute.attribute_method?("#{timestamp_attribute_name}_at")
            update_attributes(attributes)
          end
        end
      end
    end
  end
end
