module FlexibleEnum
  class SetterMethodConfigurator < AbstractConfigurator
    def apply
      attribute_name = self.attribute_name

      elements.each do |element_name, element_config|
        bang_method_name = element_config[:setter] || "#{element_name}!"
        attributes = {attribute_name => element_config[:value]}
        timestamp_attribute_name = element_config[:timestamp_attribute] || element_name

        add_instance_method(bang_method_name) do
          time = Time.now.utc
          attributes["#{timestamp_attribute_name}_on".to_sym] = time.to_date if self.class.attribute_method?("#{timestamp_attribute_name}_on")
          attributes["#{timestamp_attribute_name}_at".to_sym] = time if self.class.attribute_method?("#{timestamp_attribute_name}_at")
          update_attributes!(attributes)
        end
      end
    end
  end
end
