# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# load support folder
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# stub connect to the AWS metadata server to get the AWS credentials.
Aws.config.update(stub_responses: true)

RSpec.configure do |config|
  # load request helpers
  [RequestSpecHelper, InjectSession].each do |h|
    config.include h, type: :request
  end

  # load helpers
  [
    MockUser,
    CsvHelper,
    ActiveSupport::Testing::TimeHelpers,
    AddToSession,
    MockHelper
  ].each do |h|
    config.include h
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:each) do
    @remote_ip = '1.2.3.4'
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:remote_ip)
      .and_return(@remote_ip)
  end
end
