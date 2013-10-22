module FlexibleEnum
  class AbstractConfigurator < Struct.new(:target_class, :feature_module, :attribute_name, :module_for_elements, :elements)
    def add_class_method(method_name, &block)
      feature_module.const_get(:ClassMethods).send(:define_method, method_name, &block)
    end

    def add_instance_method(method_name, &block)
      feature_module.send(:define_method, method_name, &block)
    end
  end
end
