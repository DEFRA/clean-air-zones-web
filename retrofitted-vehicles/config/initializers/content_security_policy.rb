# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

# :nocov:
if Rails.env.production?
  Rails.application.config.content_security_policy do |policy|
    policy.default_src      :none
    policy.font_src         :self, :https, :data
    policy.img_src          :self, :https
    policy.object_src       :none
    policy.script_src       :self, :https, 'https://www.googletagmanager.com', 'https://www.google-analytics.com'
    policy.style_src        :self, :https
    policy.connect_src      :self, :https
    policy.frame_ancestors  :none
  end
end
# :nocov:

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator =
  ->(_request) { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
