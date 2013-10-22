require 'active_support/concern'
require 'active_support/inflector'

module FlexibleEnum
  module Mixin
    extend ActiveSupport::Concern

    module ClassMethods
      def flexible_enum(attribute_name, attribute_options = {}, &config)
        # Explaining variable for the class that will receive the enumerated attribute
        target_class = self

        # Methods are defined on the feature module which in turn is mixed in to the target class
        feature_module = Module.new do |m|
          extend ActiveSupport::Concern
          const_set :ClassMethods, Module.new
          def m.inspect
            "FlexibleEnum(#{target_class})"
          end
        end

        # The module that will hold references to value constants
        module_for_elements = attribute_options[:namespace] ? self.const_set(attribute_options[:namespace], Module.new) : feature_module

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
          configurator.new(target_class, feature_module, attribute_name, module_for_elements, elements).apply
        end

        # Add functionality to target inheritance chain
        target_class.send(:include, feature_module)
      end
    end
  end
end
