module FlexibleEnum
  class QuestionMethodConfigurator < AbstractConfigurator
    def apply
      elements.each do |element_name, element_config|
        attribute_name = self.attribute_name

        # Define question method
        add_instance_method("#{element_name}?") do
          self.send(attribute_name) == element_config[:value]
        end

        # Define inverse question method (if requested)
        if element_config[:inverse]
          add_instance_method("#{element_config[:inverse]}?") do
            !self.send("#{element_name}?")
          end
        end
      end
    end
  end
end
