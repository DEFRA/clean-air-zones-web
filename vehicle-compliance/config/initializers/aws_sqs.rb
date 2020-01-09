# frozen_string_literal: true

AWS_SQS = Aws::SQS::Client.new(
  region: ENV.fetch('AWS_REGION', 'eu-west-2'),
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)
