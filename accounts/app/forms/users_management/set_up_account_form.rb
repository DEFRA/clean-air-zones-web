# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # This class is used to validate user data filled in +app/views/users/set_up.html.haml+.
  class SetUpAccountForm < BaseForm
    validates :password, presence: { message: I18n.t('new_password_form.errors.password_missing') }
    validates :password_confirmation,
              presence: { message: I18n.t('new_password_form.errors.password_confirmation_missing') }
    validates :token, format: {
      with: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/,
      message: I18n.t('token_form.token_invalid')
    }, allow_blank: false
    validate :correct_password_confirmation?

    ##
    # Initializes the form
    #
    # ==== Attributes
    # * +params+ - request parameters
    #
    def initialize(params:)
      @token = params[:token]
      @password = params[:password]
      @password_confirmation = params[:password_confirmation]
    end

    # Submits the form - sets user password
    def submit
      AccountsApi::Auth.set_password(token: token, password: password)
    rescue BaseApi::Error400Exception
      errors.add(:token, :invalid, message: I18n.t('token_form.token_invalid'))
      false
    rescue BaseApi::Error422Exception
      add_password_errors(I18n.t('input_form.errors.password_complexity'))
      false
    end

    private

    # Attributes reader
    attr_reader :token, :password, :password_confirmation

    # Checks if +password+ and +password_confirmation+ are same.
    # If not, add error message to +password+. and +password_confirmation+
    def correct_password_confirmation?
      return if password == password_confirmation

      add_password_errors(I18n.t('new_password_form.errors.password_not_equal'))
    end

    # Sets error message for both inputs
    def add_password_errors(error_message)
      errors.add(:password, :invalid, message: error_message)
      errors.add(:password_confirmation, :invalid, message: error_message)
      false
    end
  end
end
