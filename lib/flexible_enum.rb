require 'active_support/lazy_load_hooks'

module FlexibleEnum
  autoload :Mixin, 'flexible_enum/mixin'
  autoload :Configuration, 'flexible_enum/configuration'
  autoload :ConstantConfigurator, 'flexible_enum/constant_configurator'
  autoload :HumanizedConfigurator, 'flexible_enum/humanized_configurator'
  autoload :QuestionMethodConfigurator, 'flexible_enum/question_method_configurator'
  autoload :BangMethodConfigurator, 'flexible_enum/bang_method_configurator'
  autoload :ScopeConfigurator, 'flexible_enum/scope_configurator'
  autoload :PotentialValuesConfigurator, 'flexible_enum/potential_values_configurator'
  autoload :Version, 'flexible_enum/version'
end

ActiveSupport.on_load :active_record do
  include FlexibleEnum::Mixin
end
