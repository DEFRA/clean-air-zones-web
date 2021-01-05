# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # This class is used to validate user data filled in +app/views/organisation_accounts/new_email_and_password.html.haml+.
  class EmailAndPasswordForm < BaseForm
    # Attribute used internally
    attr_accessor :email, :email_confirmation, :password, :password_confirmation

    # validates email format
    validates :email, :email_confirmation, format: {
      with: EMAIL_FORMAT,
      message: I18n.t('input_form.errors.invalid_format')
    }, allow_blank: true

    # validates attributes to presence
    validates :email, presence: { message: I18n.t('email_and_password_form.email_missing') }
    validates :email_confirmation,
              presence: { message: I18n.t('email_and_password_form.email_confirmation_missing') }
    validates :password, presence: { message: I18n.t('email_and_password_form.password_missing') }
    validates :password_confirmation,
              presence: { message: I18n.t('email_and_password_form.password_confirmation_missing') }

    # validates max length
    validates :email, :email_confirmation, :password, :password_confirmation,
              length: {
                maximum: 45,
                message: I18n.t('input_form.errors.maximum_length')
              }

    # validates +password+ and +password_confirmation+
    validate :correct_password_confirmation, if: lambda {
      password.present? && password_confirmation.present?
    }

    # validates +email+ and +email_confirmation+
    validate :correct_email_confirmation, if: lambda {
      email.present? && email_confirmation.present?
    }

    # Checks if +password+ and +password_confirmation+ are same.
    # If not, add error message to +password+. and +password_confirmation+
    def correct_password_confirmation
      return if password == password_confirmation

      error_message = I18n.t('password.errors.password_equality')
      errors.add(:password, :invalid, message: error_message)
      errors.add(:password_confirmation, :invalid, message: error_message)
    end

    # Checks if +email+ and +email_confirmation+ are same.
    # If not, add error message to +email+. and +email_confirmation+
    def correct_email_confirmation
      return if email == email_confirmation

      error_message = I18n.t('email.errors.email_equality')
      errors.add(:email, :invalid, message: error_message)
      errors.add(:email_confirmation, :invalid, message: error_message)
    end
  end
end
