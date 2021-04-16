# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JaquCazVcc
  # An Engine with the responsibility of coordinating the whole boot process.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # Load lib folder files
    config.autoload_paths << "#{config.root}/lib"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # name of service
    config.x.service_name = 'Drive in a Clean Air Zone'

    default_url = 'https://www.example.com'
    config.x.fleets_ui_url = ENV.fetch('FLEETS_UI_URL', default_url)
    config.x.payments_ui_url = "#{ENV.fetch('PAYMENTS_UI_URL', default_url)}/vehicles/enter_details"

    feedback_url_default = 'https://defragroup.eu.qualtrics.com/jfe/form/SV_4IoHzxu6b9Z5GRL'
    config.x.feedback_url = (ENV['FEEDBACK_URL'].presence || feedback_url_default)

    contact_email_default = 'Useraccount.Query@defra.gov.uk'
    config.x.contact_email = (ENV['CONTACT_EMAIL'].presence || contact_email_default)

    contact_form_default = 'https://contact-preprod.dvla.gov.uk/caz'
    config.x.contact_form_link = (ENV['CONTACT_FORM_LINK'].presence || contact_form_default)

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'

    # Use the lowest log level to ensure availability of diagnostic information
    # when problems arise.
    config.log_level = :debug
  end
end
