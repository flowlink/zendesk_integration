source 'https://www.rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'endpoint_base', github: 'flowlink/endpoint_base'
gem 'honeybadger'

gem 'capistrano'
gem "zendesk_api"

group :test do
  gem 'vcr'
  gem 'rspec', '2.11.0'
  gem 'webmock', '1.11.0'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
  gem 'pry'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end
