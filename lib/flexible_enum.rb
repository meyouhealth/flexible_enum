require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/object'

module FlexibleEnum
  autoload :Mixin, 'flexible_enum/mixin'
  autoload :Configuration, 'flexible_enum/configuration'
  autoload :AbstractConfigurator, 'flexible_enum/abstract_configurator'
  autoload :ConstantConfigurator, 'flexible_enum/constant_configurator'
  autoload :IdentityConfigurator, 'flexible_enum/identity_configurator'
  autoload :QuestionMethodConfigurator, 'flexible_enum/question_method_configurator'
  autoload :SetterMethodConfigurator, 'flexible_enum/setter_method_configurator'
  autoload :ScopeConfigurator, 'flexible_enum/scope_configurator'
  autoload :PotentialValuesConfigurator, 'flexible_enum/potential_values_configurator'
  autoload :Version, 'flexible_enum/version'
end

ActiveSupport.on_load :active_record do
  include FlexibleEnum::Mixin
end
