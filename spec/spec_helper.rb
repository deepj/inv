# frozen_string_literal: true

$LOAD_PATH.push(File.join(__dir__, '..'))

ENV['RACK_ENV'] ||= 'test'

require'environment'

require 'pry'
require 'database_cleaner'

RSpec.configure do |config|
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.when_first_matching_example_defined(type: :request) do
    require 'rack/test'
    config.include Rack::Test::Methods, type: :request
    require_relative 'support/api_helpers'
    config.include APIHelpers, type: :request
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = 'spec/support/examples.txt'

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
