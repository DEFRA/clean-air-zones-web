# frozen_string_literal: true

##
# Module used for connecting to Accounts API
module AccountsApi
  # API wrapper for connecting to Accounts API - Auth endpoints
  class Auth < Base
    class << self
      ##
      # Calls +/v1/auth/login+ endpoint with +POST+ method and returns details of the user.
      #
      # ==== Attributes
      #
      # * +email+ - submitted email address
      # * +password+ - submitted password
      #
      # ==== Example
      #
      #     user_attributes = AccountsApi::Auth.sign_in(email: 'test@example.com', password: 'test')
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
      # * +permissions+ - permission names of the user
      #
      # ==== Serialization
      #
      # {User model}[rdoc-ref:User] can be used to create an instance referring to the returned data
      #
      # ==== Exceptions
      #
      # * {401 Exception}[rdoc-ref:BaseApi::Error401Exception] - email and password do not match
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - email is not confirmed
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def sign_in(email:, password:)
        log_action('Login the user')
        body = { email: email.downcase, password: password }.to_json
        request(:post, '/auth/login', body: body)
      end

      ##
      # Calls +/v1/auth/password/reset/validation+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +token+ - uuid, token from reset password link
      #
      # ==== Example
      #
      #    AccountsApi::Auth.validate_password_reset(token:)
      #
      # ==== Result
      #
      # Returns true if the call was successful
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid or expired token
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def validate_password_reset(token:)
        log_action('Validating password reset token')
        body = { token: token }.to_json
        request(:post, '/auth/password/reset/validation', body: body)
        true
      end

      ##
      # Calls +/v1/auth/password/set/+ endpoint with +PUT+ method.
      #
      # ==== Attributes
      #
      # * +token+ - uuid, token from reset password link
      # * +password+ - string, new password value submitted by the user
      #
      # ==== Example
      #
      #    AccountsApi::Auth.set_password(
      #       token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
      #       password: 'Password1234!'
      #    )
      #
      # ==== Result
      #
      # Returns true if the call was successful
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid or expired token
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid password
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def set_password(token:, password:)
        log_action('Setting a new password')
        body = { token: token, password: password }.to_json
        request(:put, '/auth/password/set', body: body)
        true
      end

      ##
      # Calls +/v1/auth/password/update+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +user_id+ - uuid, account user id
      # * +old_password+ - string, old password value submitted by the user
      # * +new_password+ - string, new password value submitted by the user
      #
      # ==== Example
      #
      #    AccountsApi::Auth.update_password(
      #       user_id: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
      #       old_password: 'Password1234!',
      #       new_password: '12345!Password'
      #    )
      #
      # ==== Result
      #
      # Returns true if the call was successful
      #
      # ==== Exceptions
      #
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid password - errorCode 'oldPasswordInvalid'
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - password not complex enough - errorCode 'passwordNotValid'
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - old password reused - errorCode 'newPasswordReuse'
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def update_password(user_id:, old_password:, new_password:)
        log_action('Performing password update')
        body = { accountUserId: user_id, oldPassword: old_password, newPassword: new_password }.to_json
        request(:post, '/auth/password/update', body: body)
        true
      end

      ##
      # Calls +/v1/auth/password/reset+ endpoint with +POST+ method.
      #
      # ==== Attributes
      #
      # * +email+ - email, email address submitted by the user
      #
      # ==== Example
      #
      #    AccountsApi::Auth.initiate_password_reset(email: 'test@example.com')
      #
      # ==== Result
      #
      # Returns true if the call was successful
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid email address
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def initiate_password_reset(email:, reset_url:)
        log_action('Initiating password reset')
        body = { email: email.downcase, resetUrl: reset_url }.to_json
        request(:post, '/auth/password/reset', body: body)
        true
      end

      ##
      # Calls +/v1/auth/email/change-request+ endpoint with +PUT+ method
      #
      # ==== Attributes
      #
      # * +account_user_id+ - uuid, id of the user account
      # * +new_email+ - string, new email of the account owner
      # * +confirm_url+ - string, url which redirects to the email address updated page
      #
      # ==== Result
      #
      # Returns true if the call was successful
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def update_owner_email(account_user_id:, new_email:, confirm_url:)
        log_action('Change request email for account owner')
        body = { accountUserId: account_user_id, newEmail: new_email, confirmUrl: confirm_url }.to_json
        request(:put, '/auth/email/change-request', body: body)
        true
      end

      ##
      # Calls +/auth/email/change-confirm+ endpoint with +PUT+ method
      #
      # ==== Attributes
      #
      # * +token+ - uuid, token from reset password link
      # * +password+ - string, new password value submitted by the user
      #
      # ==== Example
      #
      #    AccountsApi::Auth.confirm_email(
      #       token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
      #       password: 'Password1234!'
      #    )
      #
      # ==== Result
      #
      # Returns true if the call was successful
      #
      # ==== Exceptions
      #
      # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid or expired token
      # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid password
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def confirm_email(token:, password:)
        log_action('Setting a new email address')
        body = { emailChangeVerificationToken: token, password: password }.to_json
        request(:put, '/auth/email/change-confirm', body: body)['newEmail']
      end
    end
  end
end
