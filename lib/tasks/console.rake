# frozen_string_literal: true

desc 'Runs a console with the application loaded'
task :console do
  $LOAD_PATH.push(File.join(__dir__, '..', '..'))

  require 'irb'
  require 'irb/completion'
  require 'environment'
  require 'app/main'

  load_dependency = ->(location) { Dir["app/#{location}/**/*.rb"].each(&method(:require)) }

  load_dependency[:api]
  load_dependency[:models]

  ActiveRecord::Base.logger = Logger.new(STDOUT)

  ARGV.clear
  IRB.start
end
