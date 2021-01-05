# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Service used to fetch the list of users and display only not owner and not removed users
  #
  class AccountUsers < BaseService
    ##
    # Initializer method
    #
    # ==== Params
    #
    # * +account_id+ - uuid, id of the account
    # * +user_id+ - uuid, id of the user
    #
    def initialize(account_id:, user_id:)
      @account_id = account_id
      @user_id = user_id
    end

    # It calls api and filter out removed users and owner users from the users list and then sorts by name in alphabetical order
    # Then converting response data to User objects
    #
    def call
      filtered_and_sorted.map { |user_data| UsersManagement::User.new(user_data) }
    end

    # Filtering out removed users and owner from the api response
    def filtered_users
      users.reject { |user| filter_users(user) }
    end

    # Returns information if account has multiple payers users
    def multi_payer_account?
      api_call['multiPayerAccount']
    end

    private

    # Gets users from the API response
    def users
      api_call['users']
    end

    # Filtering out removed users and owner from the api response and then sorts by downcase name in alphabetical order
    def filtered_and_sorted
      users.reject { |user| filter_users(user) }.sort_by { |user| user['name'].downcase }
    end

    # Call the api go get all users
    def api_call
      @api_call ||= AccountsApi::Users.users(account_id: account_id)
    end

    # Checks if user owner or removed
    def filter_users(user)
      user['owner'] == true || user['removed'] == true
    end

    # Attributes used internally
    attr_reader :account_id, :user_id
  end
end
