module FlexibleEnum
  class PotentialValuesConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      class_for_attribute.class_eval do
        define_singleton_method(attribute_name.to_s.pluralize) do
          elements.
            map {|name,config| Element.new(self, attribute_name, name, config) }.
            sort {|a,b| a.value <=> b.value }
        end

        define_singleton_method("#{attribute_name.to_s.pluralize}_by_sym") do
          x = {}
          elements.each { |name, config| x[name] = Element.new(self, attribute_name, name, config) }
          x
        end

        define_singleton_method("#{attribute_name}_const_for") do |sym_string_or_const|
          if [String, Symbol].include?(sym_string_or_const.class)
            element = send(:"#{attribute_name.to_s.pluralize}_by_sym")[:"#{sym_string_or_const.downcase}"]
            raise("Unknown enumeration element: #{sym_string_or_const}") if !element
            element.value
          else
            sym_string_or_const
          end
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
