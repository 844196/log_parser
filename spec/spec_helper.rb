$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
require 'log_parser'

TEST_CONFIG_YAML_PATH = File.expand_path('../test_config.yml', __FILE__)

Coveralls.wear!

RSpec.configure do |config|
  config.before(:suite) { puts "\e[H\e[2J" }
end
