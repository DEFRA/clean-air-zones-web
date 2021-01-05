# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # Service used to validates user params and performs call to API
  #
  class CreateUserAccount < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +organisations_params+ - hash, email and password submitted by the user
    # * +account_id+ - uuid, ID of the account on backend DB
    # * +verification_url+ - URL, the current verification_url of an app
    #
    def initialize(organisations_params:, account_id:, verification_url:)
      @organisations_params = organisations_params
      @account_id = account_id
      @verification_url = verification_url
    end

    # The caller method for the service.
    # It invokes validating, performs call to API if validation not raises exception and
    # sends verification email.
    def call
      validate_user_params
      User.serialize_from_api(perform_api_call)
    end

    private

    # Attribute used internally
    attr_reader :organisations_params, :account_id, :user, :verification_url

    # Validate user params.
    # Raises `NewPasswordException` exception if validation failed.
    def validate_user_params
      form = Organisations::EmailAndPasswordForm.new(organisations_params)
      return if form.valid?

      raise NewPasswordException, form.errors.messages
    end

    # Performs the API call to create a new account.
    #
    # It returns a new User class instance.
    def perform_api_call
      AccountsApi::Users.create_user(
        account_id: account_id,
        email: organisations_params[:email],
        password: organisations_params[:password],
        verification_url: verification_url
      )
    rescue BaseApi::Error422Exception => e
      parse_422_error(e.body['errorCode'])
    end

    # Check if api returns 422 errors. If yes assign error messages to error object and
    # raise `NewPasswordException` exception
    def parse_422_error(enum)
      errors = {}

      check_email_uniq(enum, errors)
      check_password_complexity(enum, errors)

      raise NewPasswordException, errors
    end

    # add error to +errors+ object if `emailNotUnique` enum is present
    def check_email_uniq(enum, errors)
      errors[:email] = [I18n.t('email.errors.exists')] if enum.eql?('emailNotUnique')
    end

    # add error to +errors+ object if `passwordNotValid` enum is present
    def check_password_complexity(enum, errors)
      return unless enum.eql?('passwordNotValid')

      errors[:password] = [I18n.t(
        'input_form.errors.password_complexity',
        attribute: 'Password'
      )]
    end
  end
end
