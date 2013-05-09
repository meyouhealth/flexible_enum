module FlexibleEnum
  class QuestionMethodConfigurator
    def apply(class_for_attribute, attribute_name, module_for_elements, elements)
      elements.each do |element_name, element_config|
        class_for_attribute.instance_eval do
          # Define question method
          define_method("#{element_name}?") do
            self.send(attribute_name) == element_config[:value]
          end

          # Define inverse question method (if requested)
          if element_config[:inverse]
            define_method("#{element_config[:inverse]}?") do
              !self.send("#{element_name}?")
            end
          end
        end
      end
    end
  end
end
