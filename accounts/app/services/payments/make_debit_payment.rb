# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Service used to prepare parameters and make a call to service responsible for Direct Debit payment creation.
  #
  class MakeDebitPayment < BasePayment
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +payment_data+ - hash, data coming from session storing CAZ id and payments information
    # * +account_id+ - ID of the account associated with the fleet
    # * +user_id+ - ID of the user who pays
    # * +mandate_id+ - ID of the mandate
    #
    def initialize(payment_data:, account_id:, user_id:, user_email:, mandate_id:)
      @payment_data = payment_data
      @account_id = account_id
      @user_id = user_id
      @user_email = user_email
      @mandate_id = mandate_id
    end

    ##
    # The caller method for the service.
    # Method calls +DebitsApi.create_payment+ method which performs an actual request to Payments API.
    def call
      DebitsApi.create_payment(
        account_id: account_id,
        caz_id: caz_id,
        user_id: user_id,
        user_email: user_email,
        mandate_id: mandate_id,
        transactions: transformed_transactions
      )
    end

    private

    # Attributes reader
    attr_reader :mandate_id, :account_id, :user_email
  end
end
