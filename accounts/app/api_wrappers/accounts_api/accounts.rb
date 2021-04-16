# frozen_string_literal: true

##
# Module used for connecting to Accounts API
module AccountsApi
  ##
  # API wrapper for connecting to Accounts API - accounts endpoints
  #
  class Accounts < Base
    class << self
      ##
      # Calls +/v1/accounts+ endpoint with +POST+ method and returns details of the user.
      #
      # ==== Attributes
      #
      # * +company_name+ - submitted name of the account
      # * +email+ - submitted email address
      # * +password+ - submitted password
      #
      # ==== Example
      #
      #     user_attributes = AccountsApi::Accounts.create_account(
      #       company_name: 'Test Inc.', email: 'test@example.com', password: 'test'
      #     )
      #     user = User.serialize_from_api(user_attributes)
      #
      # ==== Result
      #
      # Returned vehicles details will have the following fields:
      # * +accountId+ - uuid, ID of the account on backend DB
      # * +accountName+ - string, name of the account
      # * +accountUserId+ - uuid, ID of the user
      # * +owner+ - boolean, determines if the user is owner
      # * +email+ - email, email of the account
      #
      # ==== Serialization
      #
      # {User model}[rdoc-ref:User] can be used to create an instance referring to the returned data
      #
      # ==== Exceptions
      #
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - parameters are invalid (details in the exception body)
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def create_account(company_name:)
        log_action('Creating account company name')
        body = { accountName: company_name }.to_json
        request(:post, '/accounts', body: body)
      end

      ##
      # Calls +/v1/accounts/:accountId/users/:accountUserId/verify+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      # * +user_id+ - uuid, ID of the user
      #
      # ==== Example
      #
      #    AccountsApi::Accounts.verify_user(account_id: user.account_id, user_id: user.user_id)
      #
      # ==== Result
      #
      # Returns an empty body
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - email already confirmed
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def verify_user(token:)
        log_action('Verifying the user account')
        body = { token: token }.to_json
        request(:post, '/accounts/verify', body: body)
      end

      ##
      # Calls +/v1/accounts/:accountId/user-validations+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      # * +email+ - string, email to validate
      # * +name+ - name, name to validate
      #
      # ==== Example
      #
      #    AccountsApi::Accounts.user_validations(account_id, user.account_id, email: email, name: name)
      #
      # ==== Result
      #
      # Returns an empty body
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - email already exists
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def user_validations(account_id:, email:, name:)
        log_action('Validate the user account')
        body = { email: email.downcase, name: name }.to_json
        request(:post, "/accounts/#{account_id}/user-validations", body: body)
      end

      ##
      # Calls +/v1/accounts/:accountId/user-invitations+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      # * +user_id+ - uuid, ID of the user which will managed new user
      # * +new_user_data+ - hash, with new user data such as: email, name, verification_url and permissions
      #
      # ==== Example
      #    new_user_data = { name: name, email: email, verification_url: verification_url, permissions: ['MANAGE_VEHICLES']}
      #    AccountsApi::Accounts.user_invitations(account_id, user.account_id, user_id: user.user_id, new_user_data: new_user_data)
      #
      # ==== Result
      #
      # Returns an empty body
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - invalid user id
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def user_invitations(account_id:, user_id:, new_user_data:)
        log_action('Create user invitation')
        body = {
          isAdministeredBy: user_id,
          email: new_user_data[:email].downcase,
          name: new_user_data[:name],
          verificationUrl: new_user_data[:verification_url],
          permissions: new_user_data[:permissions]
        }.to_json
        request(:post, "/accounts/#{account_id}/user-invitations", body: body)
      end

      ##
      # Calls +/v1/accounts/:accountId+ endpoint with +GET+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      #
      # ==== Example
      #
      #    AccountsApi.account(account_id:)
      #
      # ==== Result
      #
      # Returns hash with +accountName+ property
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def account(account_id:)
        log_action('Getting company data')
        request(:get, "/accounts/#{account_id}")
      end

      ##
      # Calls +/v1/accounts/:accountId+ endpoint with +PATCH+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      # * +company_name+ - string, new company name submitted by user
      #
      # ==== Example
      #
      #    AccountsApi::Accounts.update_company_name(
      #       account_id: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
      #       company_name: "Royal Mail's"
      #    )
      #
      # ==== Result
      #
      # Returns an empty body
      #
      # ==== Exceptions
      #
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - parameters are invalid (details in the exception body)
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def update_company_name(account_id:, company_name:)
        log_action('Updating company name')
        body = { accountName: company_name }.to_json
        request(:patch, "/accounts/#{account_id}", body: body)
        true
      end

      ##
      # Calls +/v1/accounts/:accountId/vehicles/csv-exports+ endpoint with +POST+ method
      # to generate a CSV file and save it on S3 and then returns +fileUrl+.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      #
      # ==== Example
      #
      #    AccountsApi.csv_exports(
      #       account_id: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
      #    )
      #
      # ==== Result
      #
      # Returns hash with +fileUrl+ and +bucketName+ property
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - bad request
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def csv_exports(account_id:)
        log_action('Downloading a csv file')
        request(:post, "/accounts/#{account_id}/vehicles/csv-exports")['fileUrl']
      end

      ##
      # Calls +/v1/accounts/:account_id/cancellation endpoint with +POST+ method
      # to close the account.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on the backend
      #
      # ==== Example
      #
      #   AccountsApi.close_account(
      #     account_id: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
      #     reason: 'VEHICLES_COMPLIANT'
      #   )
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - bad request
      # * {404 Exception}[rdoc-ref:BaseApi::Error400Exception] - account does not exist
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def close_account(account_id:, reason:)
        log_action('Closing account')
        body = { reason: reason }.to_json
        request(:post, "/accounts/#{account_id}/cancellation", body: body)
      end
    end
  end
end
