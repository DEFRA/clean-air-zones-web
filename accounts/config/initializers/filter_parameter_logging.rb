# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  email
  confirmation
  user_id
  account_id
  account_name
  login_ip
  vrn
  authenticity_token
  vrm
  plate_number
  license_number
  vehicles
  name
  token
  account
]
