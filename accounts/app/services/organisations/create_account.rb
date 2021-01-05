# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # Service used to validate company name and perform request to API which creates the Company.
  #
  class CreateAccount < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +company_name+ - string, the company name submitted by the user
    #
    def initialize(company_name:)
      @company_name = company_name
    end

    ##
    # The caller method for the service.
    # Invokes validation for company name format and performs a request to API.
    # When response is other than :created (201) then throws an exception.
    def call
      validate_params
      created_account_data = perform_api_call
      created_account_data['accountId']
    end

    private

    # Attributes reader
    attr_reader :company_name, :confirm_fleet_check

    def validate_params
      form = Organisations::CompanyNameForm.new(company_name: company_name)
      return if form.valid?

      raise InvalidCompanyNameException, form.first_error_message
    end

    def perform_api_call
      AccountsApi::Accounts.create_account(company_name: company_name)
    rescue BaseApi::Error422Exception => e
      parse_422_error(e.body['errorCode'])
    end

    # Check if api returns 422 errors. If yes assign error messages to error object and
    # raise `UnableToCreateAccountException` exception
    def parse_422_error(enum)
      error = handle_422_error(enum)
      raise UnableToCreateAccountException, error
    end

    # returns proper error message depends on error enum
    def handle_422_error(enum)
      case enum
      when 'duplicate'
        I18n.t('company_name.errors.duplicate')
      when 'profanity'
        I18n.t('company_name.errors.profanity')
      when 'abuse'
        I18n.t('company_name.errors.abuse')
      else
        'Something went wrong'
      end
    end
  end
end
