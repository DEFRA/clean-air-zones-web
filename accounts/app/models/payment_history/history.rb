# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the payment history
  #
  class History
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    # * +user_id+ - Account User ID from backend DB
    # * +user_payments+ - boolean, to filter out company payments and show only users payments
    #
    def initialize(account_id, user_id, user_payments)
      @account_id = account_id
      @user_id = user_id
      @user_payments = user_payments
    end

    # Returns a PaymentHistory::PaginatedPayment with payments associated with the account
    # Includes data about page and total pages count
    def pagination(page:, per_page:)
      @pagination ||= begin
        data = PaymentHistoryApi.payments(
          account_id: account_id,
          user_id: user_id,
          user_payments: user_payments,
          page: page,
          per_page: per_page
        )
        PaymentHistory::PaginatedPayment.new(data)
      end
    end

    private

    # Attributes used internally
    attr_reader :account_id, :user_id, :user_payments
  end
end
