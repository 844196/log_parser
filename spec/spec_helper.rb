$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
require 'coveralls'

TEST_CONFIG_YAML_PATH = File.expand_path('../test_config.yml', __FILE__)

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

RSpec.configure do |config|
  config.before(:suite) { puts "\e[H\e[2J" }
end

require 'log_parser'
