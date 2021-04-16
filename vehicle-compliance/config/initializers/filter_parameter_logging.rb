# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  vrn
  first_name
  last_name
  email
  email_confirmation
  message
  authenticity_token
]
