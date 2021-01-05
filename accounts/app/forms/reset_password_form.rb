# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/passwords/reset.html.haml+.
class ResetPasswordForm < BaseForm
  # Attribute used internally
  attr_accessor :email_address

  # validates attributes to presence
  validates :email_address, presence: { message: I18n.t('reset_password_form.email_missing') }

  # validates max length
  validates :email_address, length: {
    maximum: 45,
    message: I18n.t('input_form.errors.maximum_length')
  }

  # validates email format
  validates :email_address, format: {
    with: EMAIL_FORMAT,
    message: I18n.t('reset_password_form.email_invalid_format')
  }, allow_blank: true
end
