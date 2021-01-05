# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems you've limited to :test, :development, or :production
Bundler.require(*Rails.groups)

module FleetsUI
  # An Engine with the responsibility of coordinating the whole boot process.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # Load custom Devise strategies
    config.autoload_paths << Rails.root.join('lib')
    # feedback url
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', 'https://defragroup.eu.qualtrics.com/jfe/form/SV_7U7lt37vNismJI9')
    # payments ui url
    config.x.payments_ui_url = ENV.fetch('PAYMENTS_UI_URL', 'dev.paycleanairzonecharge.co.uk')
    # vccs ui url
    config.x.check_air_standard_url = ENV.fetch('COMPLIANCE_CHECKER_UI_URL',
                                                'https://dev.cleanairzonevehiclecheck.co.uk')
    # service name for whole app
    config.x.service_name = 'Drive in a Clean Air Zone'
    # timeout the user session without activity.
    config.x.session_timeout_in_min = ENV.fetch('SESSION_TIMEOUT', 15).to_i
    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes
    config.time_zone = 'London'
    config.x.time_format = '%d %B %Y %H:%M:%S %Z'
    config.x.feature_direct_debits = ENV.fetch('FEATURE_DIRECT_DEBITS', 'false')
    # Configurable CSV upload size limit
    config.x.csv_file_size_limit = ENV.fetch('CSV_FILE_SIZE_LIMIT_MB', 50).to_i
    # Number of uploaded vehicles when we should change flow of compliance calculation
    config.x.large_fleet_threshold = ENV.fetch('LARGE_FLEET_THRESHOLD', 100).to_i
    # Number of uploaded vehicles when we should not allow to upload csv
    config.x.max_fleet_size = 200_000
    config.x.contact_form_link = ENV.fetch('CONTACT_FORM_LINK', 'contact-preprod.dvla.gov.uk/caz')
  end
end
