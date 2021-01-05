# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # This class is used to validate users email filled in +app/views/account_details/primary_users/edit_email.html.haml+
  class EditUserEmailForm < BaseForm
    # Attributes accessor
    attr_accessor :account_id, :current_email, :email, :confirmation

    # Maximum length for email address
    MAX_EMAIL_LENGTH = 128

    # validates +email+ and +confirmation+ presence
    validates :email, :confirmation, presence: {
      message: I18n.t('edit_user_email_form.errors.email_missing')
    }

    # validates +email+ and +confirmation+ length
    validates :email, :confirmation, length: {
      maximum: MAX_EMAIL_LENGTH,
      too_long: I18n.t('edit_user_email_form.errors.email_too_long')
    }

    # validates +email+ and +confirmation+ format
    validates :email, :confirmation, format: {
      with: EMAIL_FORMAT,
      message: I18n.t('edit_user_email_form.errors.email_invalid_format')
    }, allow_blank: true

    # validates +email+ and +confirmation+ match
    validate :correct_email_confirmation

    # validates +email+ against duplication
    validate :email_not_duplicated, if: :check_if_email_unique?

    # Add errors message to +email+ and +confirmation+
    def add_invalid_email_errors
      error_message = I18n.t('edit_user_email_form.errors.email_invalid_format')
      errors.add(:email, :invalid, message: error_message)
      errors.add(:confirmation, :invalid, message: error_message)
    end

    private

    # Determines if email uniqueness should be checked
    def check_if_email_unique?
      email.present? && email == confirmation && email.length <= MAX_EMAIL_LENGTH
    end

    # Checks if +email+ and +confirmation+ are same.
    # If not, add error message to +email+ and +confirmation+
    def correct_email_confirmation
      return if email == confirmation

      error_message = I18n.t('edit_user_email_form.errors.emails_not_equal')
      errors.add(:email, :invalid, message: error_message)
      errors.add(:confirmation, :invalid, message: error_message)
    end

    # Checks if +email+ are unique.
    # If not, add error message to +email+.
    def email_not_duplicated
      return if email_unique?

      error_message = I18n.t('edit_user_email_form.errors.email_duplicated')
      errors.add(:email, :invalid, message: error_message)
    end

    # Checks if email is unique
    def email_unique?
      AccountsApi::Accounts.user_validations(account_id: account_id, name: email, email: email)
      true
    rescue BaseApi::Error400Exception => e
      log_error(e)
      false
    end
  end
end
