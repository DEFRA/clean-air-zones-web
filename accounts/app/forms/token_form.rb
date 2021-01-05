# frozen_string_literal: true

##
# Form used to validate reset password token
class TokenForm < BaseForm
  # Attributes accessor
  attr_accessor :token

  validates :token, presence: { message: I18n.t('token_form.token_missing') }
  validate :backend_validation, if: ->(form) { form.token.present? }

  # Validates token against backend endpoint by calling AccountsApi::Auth.validate_password_reset
  def backend_validation
    AccountsApi::Auth.validate_password_reset(token: token)
  rescue BaseApi::Error400Exception
    errors.add(:token, I18n.t('token_form.token_invalid'))
  end
end
