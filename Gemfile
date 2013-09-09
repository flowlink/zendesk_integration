source 'https://www.rubygems.org'

gem 'endpoint_base', github: 'spree/endpoint_base'
gem 'thin'
gem 'tzinfo'
gem 'capistrano'
gem "zendesk_api"

group :test do
  gem 'vcr'
  gem 'rspec', '2.11.0'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
  gem 'debugger'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

