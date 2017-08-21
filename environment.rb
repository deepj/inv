# frozen_string_literal: true

$LOAD_PATH.push(File.join(__dir__, 'app'))
$LOAD_PATH.push(__dir__)

require 'bundler'

Bundler.require(:default, ENV.fetch('RACK_ENV', 'development'))

require 'active_record'
require_relative 'config/app_config'
require_relative 'lib/database_url_builder'

begin
  ActiveRecord::Base.establish_connection(DatabaseURLBuilder.build)
rescue URI::InvalidURIError
  abort('Invalid database credentials!')
end

ActiveRecord::Base.default_timezone = :utc
