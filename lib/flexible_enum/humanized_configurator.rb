module FlexibleEnum
  class HumanizedConfigurator < AbstractConfigurator
    def apply
      configurator = self

      add_class_method("human_#{attribute_name}") do |value|
        configurator.human_name_for(value)
      end

      add_instance_method("human_#{attribute_name}") do
        value = send(configurator.attribute_name)
        configurator.human_name_for(value)
      end
    end

    def human_name_for(value)
      element_name, element_config = elements.select{|e,c| c[:value] == value }.first
      element_config[:human_name] || element_name.to_s.humanize
    end
  end
end
