require 'active_support/concern'
require 'active_support/inflector'

module FlexibleEnum
  module Mixin
    extend ActiveSupport::Concern

    module ClassMethods
      def flexible_enum(attribute_name, attribute_options = {}, &config)
        # Explaining variable for the class that will receive the enumerated attribute
        class_for_attribute = self

        # Define namespaced module if needed, otherwise reference the class containing the enumerated attribute
        module_for_elements = attribute_options[:namespace] ? self.const_set(attribute_options[:namespace], Module.new) : class_for_attribute

        # Read configuration
        elements = Configuration.load(&config).elements

        # Configure the target object for the given attribute
        configurators = [ConstantConfigurator,
                         HumanizedConfigurator,
                         QuestionMethodConfigurator,
                         BangMethodConfigurator,
                         ScopeConfigurator,
                         PotentialValuesConfigurator]
        configurators.each do |configurator|
          configurator.new.apply(class_for_attribute, attribute_name, module_for_elements, elements)
        end
      end
    end
  end
end
