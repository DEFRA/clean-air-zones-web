# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Service used to close the account.
  class CloseAccount < BaseService
    ##
    # Initializer method
    #
    # ==== Attributes
    # * +account_id+ - uuid, ID of the account on the backend DB
    # * +reason+ - string, the reason of the account closure
    #
    def initialize(account_id:, reason:)
      @account_id = account_id
      @reason = reason
    end

    ##
    # The caller method for the service.
    #
    def call
      AccountsApi::Accounts.close_account(account_id: account_id, reason: reason)
    end

    private

    # Private attr readers
    attr_reader :account_id, :reason
  end
end
