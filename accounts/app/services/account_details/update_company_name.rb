# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Service used to validate company name and perform request to API which updates the company name.
  #
  class UpdateCompanyName < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +account_id+ - uuid, ID of the account on backend DB
    # * +company_name+ - string, the company name submitted by the user
    #
    def initialize(account_id:, company_name:)
      @account_id = account_id
      @company_name = company_name
    end

    ##
    # The caller method for the service.
    # Invokes validation for company name format and performs a request to API.
    def call
      validate_params
      perform_api_call
    end

    private

    # Attributes reader
    attr_reader :account_id, :company_name

    # Company name validation
    def validate_params
      form = Organisations::CompanyNameForm.new(company_name: company_name)
      return if form.valid?

      raise InvalidCompanyNameException, form.first_error_message
    end

    # Performs company name update by calling +/v1/accounts/:accountId+ with +PATCH+ method
    def perform_api_call
      AccountsApi::Accounts.update_company_name(account_id: account_id, company_name: company_name)
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
        I18n.t('company_name.errors.duplicate_alternative')
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
