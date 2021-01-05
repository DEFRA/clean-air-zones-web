# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# load support folder
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config| # rubocop:disable Metrics/BlockLength
  # add helpers to request rspec classes
  [RequestSpecHelper,
   StringCountHelper,
   AddToSession,
   AddToRedis,
   FleetFactory,
   ChargeableVehiclesFactory].each do |helper|
    config.include helper, type: :request
  end

  # add helpers to rspec classes
  [
    StrongParams,
    UsersFactory,
    ActiveSupport::Testing::TimeHelpers,
    FixturesHelpers,
    MockedResponses,
    UsersManagement::MockedResponses,
    AccountDetails::MockedResponses
  ].each do |helper|
    config.include helper
  end

  config.before do
    @vrn = 'ABC123'
    @uuid = '5cd7441d-766f-48ff-b8ad-1809586fea37'
    @remote_ip = '1.2.3.4'
    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(@remote_ip)
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
end
