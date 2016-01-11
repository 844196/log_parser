module LogParser
  DEFAULT_CONFIG_YAML_PATH = File.expand_path('../../config/default.yml', File.dirname(__FILE__))

  class Configuration
    include Singleton

    @@defaults = YAML.load_file(DEFAULT_CONFIG_YAML_PATH)

    def initialize
      @@defaults.each {|k,v| self.send("#{k}=", v) }
    end

    attr_accessor *@@defaults.keys
  end

  class << self
    def config
      Configuration.instance
    end

    def configure
      yield(config)
    end

    def yaml_load(args)
      if args[:path]
        YAML.load_file(args[:path]).each do |k, v|
          config.instance_variable_set("@#{k}", v)
        end
      elsif args[:file_obj]
        YAML.load(args[:file_obj]).each do |k, v|
          config.instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end
