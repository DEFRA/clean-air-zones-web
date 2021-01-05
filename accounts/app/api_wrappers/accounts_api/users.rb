# frozen_string_literal: true

##
# Module used for connecting to Accounts API
module AccountsApi
  ##
  # API wrapper for connecting to Accounts API - Users endpoints
  #
  class Users < Base
    class << self
      ##
      # Calls +/v1/accounts/:accountId/users+ endpoint with +POST+ method and returns details of the created user
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      # * +email+ - submitted email address
      # * +password+ - submitted password
      # * +verification_url+ - url to verify account.
      #
      # ==== Example
      #
      #     user_attributes = AccountsApi.users(
      #       company_name: 'Test Inc.',
      #       email: 'test@example.com',
      #       password: 'test',
      #       verification_url: 'http://exmaple.url'
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
      def create_user(account_id:, email:, password:, verification_url:)
        log_action('Creating a user account')
        body = create_account_user_body(email, password, verification_url)
        request(:post, "/accounts/#{account_id}/users", body: body)
      end

      ##
      # Calls +/v1/accounts/:accountId/users+ endpoint with +GET+ method and returns owner users for current user
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, id of the account
      #
      # ==== Result
      #
      # Returned vehicles details will have the following fields:
      # * +users+ - array of user objects
      #   * +accountId+ - uuid, id of the user
      #   * +email+ - email, email of the user
      #   * +name+ - string, name of the user
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def users(account_id:)
        log_action('Getting users')
        request(:get, "/accounts/#{account_id}/users")
      end

      ##
      # Calls +/v1/accounts/:accountId/users/:accountUserId+ endpoint with +GET+ method and returns user details
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, id of the account
      # * +account_user_id+ - uuid, id of the user account
      #
      # ==== Result
      #
      # Returned user details will have the following fields:
      # * +email+ - email, email of the user
      # * +name+ - string, name of the user
      # * +owner+ - boolean, determines if the user is owner
      # * +permissions+ - permission names of the user
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account or user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def user(account_id:, account_user_id:)
        log_action('Getting user details')
        request(:get, "/accounts/#{account_id}/users/#{account_user_id}")
      end

      ##
      # Calls +/v1/accounts/:accountId/users/:accountUserId+ endpoint with +PATCH+ method
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, id of the account
      # * +account_user_id+ - uuid, id of the user account
      # * +permissions+ - permission names of the user
      #
      # ==== Result
      #
      #  Returns an empty body
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account or user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def update_user(account_id:, account_user_id:, permissions: nil, name: nil)
        log_action('Updating user permissions')
        body = create_account_user_update_payload(permissions: permissions, name: name)
        request(:patch, "/accounts/#{account_id}/users/#{account_user_id}", body: body)
      end

      ##
      # Calls +/v1/accounts/:accountId/users/:accountUserId+ endpoint with +DELETE+ method
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, id of the account
      # * +account_user_id+ - uuid, id of the user account
      #
      # ==== Result
      #
      #  Returns an empty body
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account or user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def delete_user(account_id:, account_user_id:)
        log_action('Deleting user')
        request(:delete, "/accounts/#{account_id}/users/#{account_user_id}")
      end

      ##
      # Calls +/v1/accounts/:accountId/users/:accountUserId/verifications+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, ID of the account on backend DB
      # * +user_id+ - uuid, ID of the user
      # * +verification_url+ - url to verify account.
      #
      # ==== Example
      #
      #     AccountsApi.resend_verification(
      #       account_id: user.account_id,
      #       user_id: user.user_id
      #       verification_url: 'http://exmaple.url'
      #     )
      #
      # ==== Result
      #
      # Returns an empty body
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def resend_verification(account_id:, user_id:, verification_url:)
        log_action('Resend verification email of user account')
        body = { verificationUrl: verification_url }.to_json
        request(:post, "/accounts/#{account_id}/users/#{user_id}/verifications", body: body)
      end

      ##
      # Calls +/v1/users/:accountUserId+ endpoint with +GET+ method and returns account details
      #
      # ==== Attributes
      #
      # * +account_user_id+ - uuid, id of the user account
      #
      # ==== Result
      #
      # Returned account details will have the following fields:
      # * +accountUserId+ - uuid, ID of the user
      # * +accountId+ - uuid, ID of the account
      # * +accountName+ - string, name of the account
      # * +name+ - string, name of the user
      # * +email+ - email, email of the user
      # * +owner+ - boolean, determines if the user is owner
      # * +removed+ - boolean, determines if the user was removed
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def account_details(account_user_id:)
        log_action('Getting account details')
        request(:get, "/users/#{account_user_id}")
      end

      private

      # prepares create user for account request body.
      def create_account_user_body(email, password, verification_url)
        {
          email: email.downcase,
          password: password,
          verificationUrl: verification_url
        }.to_json
      end

      # prepares json payload for patch user action
      def create_account_user_update_payload(permissions:, name:)
        {
          permissions: permissions,
          name: name
        }.compact.to_json
      end
    end
  end
end
