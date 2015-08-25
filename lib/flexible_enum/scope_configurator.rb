module FlexibleEnum
  class ScopeConfigurator < AbstractConfigurator
    def apply
      configurator = self

      elements.each do |element_name, element_config|
        add_class_method(scope_name(element_name)) do
          where(configurator.attribute_name => element_config[:value])
        end
      end
    end

    private

    def scope_name(option)
      if feature_module == module_for_elements
        option
      else
        "#{module_for_elements.to_s.split('::').last.underscore.singularize}_#{option}"
      end
    end
  end
end
