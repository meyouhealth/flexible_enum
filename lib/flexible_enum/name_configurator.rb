module FlexibleEnum
  class NameConfigurator < AbstractConfigurator
    def apply
      configurator = self

      add_instance_method("#{attribute_name}_name") do
        value = send(configurator.attribute_name)
        configurator.name_for(value)
      end

      add_class_method("human_#{attribute_name}") do |value|
        configurator.human_name_for(value)
      end

      add_instance_method("human_#{attribute_name}") do
        value = send(configurator.attribute_name)
        configurator.human_name_for(value)
      end
    end

    def name_for(value)
      if value
        element_info(value).first.to_s
      else
        nil
      end
    end

    def human_name_for(value)
      if value
        element_name, element_config = element_info(value)
        element_config[:human_name] || element_name.to_s.humanize
      else
        nil
      end
    end

    private

    def element_info(value)
      elements.select{|e,c| c[:value] == value }.first
    end
  end
end
