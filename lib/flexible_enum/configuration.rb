module FlexibleEnum
  class Configuration
    def self.load(&block)
      new.tap {|i| i.instance_eval(&block) }
    end

    def initialize
      @config = {}
    end

    def elements
      @config.dup
    end

    def method_missing(element_name, value, options = {})
      @config[element_name] = options
      @config[element_name][:value] = value
    end
  end
end
