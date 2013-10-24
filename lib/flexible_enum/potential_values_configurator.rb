module FlexibleEnum
  class PotentialValuesConfigurator < AbstractConfigurator
    def apply
      configurator = self

      add_class_method(attribute_name.to_s.pluralize) do
        configurator.elements.map(&configurator.option_builder_for_target(self)).sort_by(&:value)
      end

      add_class_method("#{attribute_name.to_s.pluralize}_by_sym") do
        configurator.elements.inject({}) do |all_options, (element_name, element_config)|
          all_options.merge element_name => configurator.option_builder_for_target(self).call(element_name, element_config)
        end
      end

      add_class_method("#{attribute_name}_value_for") do |sym_string_or_const|
        element_by_symbol = send(:"#{configurator.attribute_name.to_s.pluralize}_by_sym")[:"#{sym_string_or_const.to_s.downcase}"]
        element_by_value = send(configurator.attribute_name.to_s.pluralize).select { |e| e.value == sym_string_or_const }.first
        (element_by_symbol || element_by_value).try(:value) or raise("Unknown enumeration element: #{sym_string_or_const}")
      end
    end

    def option_builder_for_target(target_instance)
      proc { |element_name, element_config| Option.new(target_instance, attribute_name, element_name, element_config) }
    end

    class Option < Struct.new(:target_class, :attribute_name, :element_name, :element_config)
      def name
        element_name.to_s
      end

      def human_name
        target_class.send("human_#{attribute_name}", value)
      end

      def value
        element_config[:value]
      end

      def [](key)
        element_config[key]
      end
    end
  end
end
