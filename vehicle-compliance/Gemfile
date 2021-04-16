# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.1.3'

gem 'activerecord-nulldb-adapter'
gem 'bootsnap', require: false
gem 'haml'
gem 'httparty'
gem 'puma'
gem 'sdoc', require: false
gem 'sqlite3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker'

group :development, :test do
  gem 'dotenv-rails'
  gem 'haml-rails'
  gem 'rspec-rails'
  gem 'rubocop-rspec', require: false
  gem 'ruby_jard'
  gem 'yard'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'i18n-tasks'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rubocop-rails'
  gem 'scss_lint-govuk', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'webdrivers'
  gem 'webmock'
end
