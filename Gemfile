# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activerecord',             '5.2.0'
gem 'active_record_migrations', '5.2.0.1'
gem 'puma',                     '3.12.0'
gem 'pg',                       '1.2.3'

# Grape API
gem 'grape',                          '1.0.3'
gem 'grape-active_model_serializers', '1.5.2'

# Dry-rb
gem 'dry-types',       '0.13.2'
gem 'dry-validation',  '0.12.1'
gem 'dry-initializer', '2.4.0'

group :development do
  gem 'rubocop', '0.61.1', require: false
end

group :test do
  gem 'json-schema',      '2.8.0'
  gem 'rspec',            '3.7.0'
  gem 'factory_bot',      '4.10.0'
  gem 'database_cleaner', '1.7.0'
end

group :development, :test do
  gem 'pry',         '0.11.3'
  gem 'rb-readline', '0.5.5'
end
