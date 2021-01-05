# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Service used to validate password and perform request to API which updates the email address
  #
  class UpdateEmail < BaseService
    # Attributes reader
    attr_reader :errors, :new_user_email, :password

    ##
    # Initializer method
    #
    # ==== Attributes
    # * +password+ - string, new password value submitted by the user
    # * +password_confirmation+ - string, new password confirmation submitted by the user
    # * +token+ - uuid, token from update email address link
    #
    def initialize(password:, password_confirmation:, token:)
      @password = password
      @password_confirmation = password_confirmation
      @token = token
    end

    # The caller method for the service. Returns class object.
    def call
      self
    end

    # Validates password and perform request to API
    def valid?
      form = NewPasswordForm.new(password: password, password_confirmation: password_confirmation)
      if form.valid?
        @new_user_email = api_call
      else
        @errors = form.errors.messages
        false
      end
    end

    private

    # Attributes reader
    attr_reader :password_confirmation, :token

    # Calls AccountsApi::Auth.confirm_email with given password and the token
    def api_call
      AccountsApi::Auth.confirm_email(token: token, password: password)
    rescue BaseApi::Error422Exception => e
      @errors = { password: parse_422_error(e.body['errorCode']) }
      false
    end

    # Returns correct error message for 422 error
    def parse_422_error(code)
      case code
      when 'passwordNotValid'
        [I18n.t('input_form.errors.password_complexity')]
      when 'newPasswordReuse'
        [I18n.t('update_password_form.errors.password_reused')]
      when 'expired', 'invalid'
        [I18n.t('update_password_form.errors.token_expired')]
      else
        ['Something went wrong']
      end
    end
  end
end
