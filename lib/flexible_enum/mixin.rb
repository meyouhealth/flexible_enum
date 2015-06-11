require 'active_support/concern'
require 'active_support/inflector'

module FlexibleEnum
  module Mixin
    extend ActiveSupport::Concern

    module ClassMethods
      def flexible_enums
        @flexible_enums ||= {}
      end

      def flexible_enum(attribute_name, attribute_options = {}, &config)
        # Methods are defined on the feature module which in turn is mixed in to the target class
        feature_module = Module.new do |m|
          extend ActiveSupport::Concern
          const_set :ClassMethods, Module.new
          def m.inspect
            "FlexibleEnum(#{self})"
          end
        end

        # The module that will hold references to value constants
        module_for_elements = attribute_options[:namespace] ? self.const_set(attribute_options[:namespace], Module.new) : feature_module

        # Read configuration
        elements = Configuration.load(&config).elements

        # Configure the target object for the given attribute
        configurators = [ConstantConfigurator,
                         IdentityConfigurator,
                         QuestionMethodConfigurator,
                         SetterMethodConfigurator,
                         ScopeConfigurator,
                         PotentialValuesConfigurator]
        configurators.each do |configurator|
          configurator.new(feature_module, attribute_name, module_for_elements, elements).apply
        end

        # Add functionality to target inheritance chain
        send(:include, feature_module)

        flexible_enums[attribute_name] = public_send("#{attribute_name.to_s.pluralize}_by_sym")
      end
    end
  end
end
