# frozen_string_literal: true

require 'yaml'
require 'erb'

require 'lib/symbolize_keys'

environment = ENV.fetch('RACK_ENV', 'development')

main_config_yaml = File.read(File.join(__dir__, 'application.yml'))
main_config = YAML.load(ERB.new(main_config_yaml).result)[environment] || {}

abort('The configuration could not be loaded or missing!') if main_config.empty?

APP_CONFIG = SymbolizeKeys.symbolize(main_config)
