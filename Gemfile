source 'https://rubygems.org'

ruby '2.4.1'

gem 'activerecord',             '5.1.3'
gem 'active_record_migrations', '5.0.2.1'
gem 'puma',                     '3.10.0'
gem 'grape',                    '1.0.0'
gem 'pg',                       '0.21.0'

# SSL
gem 'rack-ssl-enforcer', '0.2.9'

group :development do
  gem 'rubocop', '0.49.1', require: false
  gem 'rufo',    '0.1.0',  require: false
end

group :test do
  gem 'rspec',            '3.6.0'
  gem 'factory_girl',     '4.8.0'
  gem 'database_cleaner', '1.6.1'
end

group :development, :test do
  gem 'pry',         '0.10.4'
  gem 'rb-readline', '0.5.5'
end
