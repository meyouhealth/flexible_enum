module FlexibleEnum
  class PotentialValuesConfigurator < AbstractConfigurator
    def apply
      configurator = self

      add_class_method(attribute_name.to_s.pluralize) do
        configurator.elements.
          map {|name,config| Element.new(self, configurator.attribute_name, name, config) }.
          sort {|a,b| a.value <=> b.value }
      end

      add_class_method("#{attribute_name.to_s.pluralize}_by_sym") do
        x = {}
        configurator.elements.each { |name, config| x[name] = Element.new(self, configurator.attribute_name, name, config) }
        x
      end

      add_class_method("#{attribute_name}_value_for") do |sym_string_or_const|
        element = send(:"#{configurator.attribute_name.to_s.pluralize}_by_sym")[:"#{sym_string_or_const.to_s.downcase}"]
        element ||= send(configurator.attribute_name.to_s.pluralize).select { |e| e.value == sym_string_or_const }.first
        raise("Unknown enumeration element: #{sym_string_or_const}") if !element
        element.value
      end
    end

    class Element
      def initialize(parent_class, attribute_name, element_name, element_config)
        @parent_class = parent_class
        @attribute_name = attribute_name
        @element_name   = element_name
        @element_config = element_config
      end

      def name
        @element_name.to_s
      end

      def human_name
        @parent_class.send("human_#{@attribute_name}", value)
      end

      def value
        @element_config[:value]
      end

      def [](key)
        @element_config[key]
      end
    end
  end
end
