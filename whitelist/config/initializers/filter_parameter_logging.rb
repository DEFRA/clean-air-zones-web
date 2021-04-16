# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  authenticity_token
  confirmation_code
  email
  login_ip
  password
  sub
  username
  vrn
]
