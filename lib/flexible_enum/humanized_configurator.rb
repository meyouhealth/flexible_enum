module FlexibleEnum
  class HumanizedConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      @elements = elements
      configurator = self

      # Define human_<attribute_name> class method
      class_for_attribute.class_eval do
        define_singleton_method("human_#{attribute_name}") do |value|
          configurator.human_name_for(value)
        end
      end

      # Define human_<attribute_name> instance method
      class_for_attribute.instance_eval do
        define_method("human_#{attribute_name}") do
          value = self.send(attribute_name)
          configurator.human_name_for(value)
        end
      end
    end

    def human_name_for(value)
      element_name, element_config = @elements.select{|e,c| c[:value] == value }.first
      element_config[:human_name] || element_name.to_s.humanize
    end
  end
end
