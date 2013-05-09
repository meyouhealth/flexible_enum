module FlexibleEnum
  class PotentialValuesConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      class_for_attribute.class_eval do
        define_singleton_method(attribute_name.to_s.pluralize) do
          elements.
            map {|name,config| Element.new(self, attribute_name, name, config) }.
            sort {|a,b| a.value <=> b.value }
        end
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
