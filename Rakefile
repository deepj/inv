# frozen_string_literal: true

require_relative 'environment'

Dir.glob('lib/tasks/**/*.rake').each(&method(:import))

ActiveRecordMigrations.configure do |config|
  config.database_configuration = {
    environment => {
      'adapter'  => APP_CONFIG.fetch(:adapter),
      'database' => APP_CONFIG.fetch(:database),
      'username' => APP_CONFIG.fetch(:username),
      'password' => APP_CONFIG.fetch(:password),
      'host'     => APP_CONFIG.fetch(:host),
      'port'     => APP_CONFIG.fetch(:port)
    }
  }

  config.schema_format = :ruby
end

ActiveRecordMigrations.load_tasks
