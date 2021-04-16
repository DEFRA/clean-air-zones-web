# frozen_string_literal: true

##
# Module used for manage users flow
#
module UsersManagement
  ##
  # Service user to check if the provided user is Direct Debit creator for the provided account.
  #
  class IsDirectDebitCreator < BaseService
    ##
    # Initializer method
    #
    # ==== Params
    #
    # * +account_id+ - uuid, id of the account
    # * +account_user_id+ - uuid, id of the user
    #
    def initialize(account_id:, account_user_id:)
      @account_id = account_id
      @account_user_id = account_user_id
    end

    # It calls api and selects only the mandates that were created by the provider account user.
    # Returns boolean which indicates if there are any mandates created by the user.
    def call
      mandates_created_by_user.any?
    end

    private

    attr_reader :account_id, :account_user_id

    # Performs an api call to fetch direct debit mandates for the provided account id.
    def mandates
      @mandates ||= DebitsApi.mandates(account_id: account_id)
    end

    # Selects mandates created by the provided account user.
    def mandates_created_by_user
      mandates.map { |e| e['mandates'] }
              .flatten
              .select { |e| e['accountUserId'] == account_user_id }
    end
  end
end
