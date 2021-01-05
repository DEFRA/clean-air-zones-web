# frozen_string_literal: true

##
# Class used to validate form rendered on the +app/views/passwords/edit.html.haml+
# Inherits from NewPasswordForm
class UpdatePasswordForm < NewPasswordForm
  validates :old_password, presence: { message: I18n.t('update_password_form.errors.old_password_missing') }

  ##
  # Initializes the form
  #
  # ==== Attributes
  # * +user_id+ - uuid, account user id
  # * +old_password+ - string, old password value submitted by the user
  # * +password+ - string, new password value submitted by the user
  # * +password_confirmation+ - string, new password confirmation submitted by the user
  #
  def initialize(user_id:, old_password:, password:, password_confirmation:)
    @user_id = user_id
    @old_password = old_password
    @password = password
    @password_confirmation = password_confirmation
  end

  # Submits the form - updates user password
  def submit
    perform_api_call
  rescue BaseApi::Error422Exception => e
    parse_422_error(e.body['errorCode'])
    false
  end

  private

  # Attributes reader
  attr_reader :user_id, :old_password, :password

  # Performs call to AccountsApi::Auth.update_password
  def perform_api_call
    AccountsApi::Auth.update_password(user_id: user_id, old_password: old_password, new_password: password)
  end

  # Returns correct error message for 422 error
  def parse_422_error(code)
    case code
    when 'passwordNotValid'
      errors.add(:password, :invalid, message: I18n.t('input_form.errors.password_complexity'))
    when 'oldPasswordInvalid'
      errors.add(:old_password, :invalid, message: I18n.t('update_password_form.errors.old_password_invalid'))
    when 'newPasswordReuse'
      errors.add(:password, :invalid, message: I18n.t('update_password_form.errors.password_reused'))
    else
      errors.add(:password, :invalid, message: 'Something went wrong')
    end
  end
end
