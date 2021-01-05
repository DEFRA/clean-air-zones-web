# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # Service used to verify account, call verify endpoint in the backend API
  #
  # ==== Usage
  #    Organisations::VerifyAccount.call(token: params[:token])
  #
  class VerifyAccount < BaseService
    # Initializer method used by class level +.call+ method
    #
    # ==== Attributes
    # * +token+ - string, encrypted token containing user related information like +user_id+
    #
    def initialize(token:)
      @token = token
    end

    # Execution method used by class level +.call+ method.
    # It decrypts the token and performs API call.
    #
    # It return true if both actions were successful, and false if something fails.
    #
    def call
      perform_api_call
    rescue ApiException => e
      log_error(e)
      :invalid
    end

    private

    # Attributes reader
    attr_reader :token

    # Performs the API call to verification endpoint.
    # raise `UserAlreadyConfirmedException` exception if user already confirmed
    def perform_api_call
      AccountsApi::Accounts.verify_user(token: token)
      :success
    rescue BaseApi::Error422Exception => e
      error_code = e.body['errorCode']
      handle_422_error(error_code)
    end

    # Returns proper status which will be used in controller to redirect.
    def handle_422_error(error_code)
      raise UserAlreadyConfirmedException if error_code == 'emailAlreadyVerified'
      return :invalid if error_code == 'invalid'

      :expired if error_code == 'expired'
    end
  end
end
