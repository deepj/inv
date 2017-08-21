# frozen_string_literal: true

desc 'Prints routes'
task :routes do
  $LOAD_PATH.push(File.join(__dir__, '..', '..'))

  require 'environment'
  require 'app/main'

  API::Main.routes.each do |route|
    puts "version=#{route.options[:version]}, method=#{route.options[:method]}, path=#{route.pattern.origin}"
  end
end
