# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Service used to prepare parameters and make a call to service responsible for credit
  # card payment creation.
  #
  class MakeCardPayment < BasePayment
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +payment_data+ - hash, data coming from session storing CAZ id and payments information
    # * +user_id+ - ID of the user who pays
    # * +return_url+ - URL where GOV.UK Pay should redirect after the payment is done
    #
    def initialize(payment_data:, user_id:, return_url:)
      @payment_data = payment_data
      @user_id = user_id
      @return_url = return_url
    end

    ##
    # The caller method for the service.
    # Method calls +PaymentsApi.create_payment+ method which performs an actual
    # request to Payments API.
    #
    def call
      PaymentsApi.create_payment(
        caz_id: caz_id,
        return_url: return_url,
        user_id: user_id,
        transactions: transformed_transactions
      )
    end

    private

    # Attributes reader
    attr_reader :return_url
  end
end
