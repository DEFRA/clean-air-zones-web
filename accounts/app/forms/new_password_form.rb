# frozen_string_literal: true

##
# Class used to validate form rendered on the +app/views/passwords/index.html.haml+ or on the +app/views/account_details/emails/confirm_email.html.haml+
class NewPasswordForm < BaseForm
  # Attributes accessor
  attr_accessor :password, :password_confirmation

  validates :password, presence: { message: I18n.t('new_password_form.errors.password_missing') }
  validate :correct_password_match

  validates :password_confirmation,
            presence: { message: I18n.t('new_password_form.errors.password_confirmation_missing') }
  validate :correct_password_confirmation_match

  # Checks if +password+ and +password_confirmation+ are same.
  # If not, add error message to +password+
  def correct_password_match
    return if password == password_confirmation

    errors.add(:password, :invalid, message: I18n.t('new_password_form.errors.password_not_equal'))
  end

  # Checks if +password+ and +password_confirmation+ are same.
  # If not, add error message to +password_confirmation+
  def correct_password_confirmation_match
    return if password == password_confirmation

    errors.add(:password_confirmation, :invalid,
               message: I18n.t('new_password_form.errors.password_not_equal'))
  end
end
