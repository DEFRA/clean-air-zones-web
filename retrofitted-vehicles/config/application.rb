# frozen_string_literal: true

require_relative 'boot'

# This is not loaded in rails/all but inside active_record so add it if
# you want your models work as expected
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CsvUploader
  # The class is responsible for building the middleware stack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.eager_load_paths << Rails.root.join('lib')

    # timeout the user session without activity.
    config.x.session_timeout_in_min = ENV.fetch('SESSION_TIMEOUT', 15).to_i
    # link to feedback page.
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', 'https://defragroup.eu.qualtrics.com/jfe/form/SV_7PZ3p21Nt1t5A0t')
    # name of service
    config.x.service_name = 'Retrofitted Vehicles Upload Portal'
    default_email = 'CAZ.DataUpload.Support@informed.com'
    config.x.contact_email = default_email
    config.x.service_email = ENV.fetch('SES_FROM_EMAIL', default_email)

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'
    config.x.time_format = '%d %B %Y %H:%M:%S %Z'

    # https://github.com/aws/aws-sdk-rails
    config.action_mailer.delivery_method = :aws_sdk

    # https://stackoverflow.com/questions/49086693/how-do-i-remove-mail-html-content-from-rails-logs
    config.action_mailer.logger = nil

    # Configurable CSV upload size limit
    config.x.csv_file_size_limit = ENV.fetch('CSV_FILE_SIZE_LIMIT_MB', 50).to_i
  end
end
