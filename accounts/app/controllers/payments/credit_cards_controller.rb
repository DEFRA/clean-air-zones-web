# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Controller used to pay by credit card
  #
  class CreditCardsController < ApplicationController
    include CazLock
    include CheckPermissions

    # Makes a request to initiate card payment and redirects to the response url
    #
    # ==== Path
    #     GET /payments/initiate
    #
    def initiate
      service_response = Payments::MakeCardPayment.call(payment_data: payment_data,
                                                        user_id: current_user.user_id,
                                                        return_url: result_payments_url)
      store_payment_data_in_session(service_response)
      redirect_to service_response['nextUrl']
    end

    ##
    # The page used as a landing point after the GOV.UK payment process.
    #
    # Calls +/payments/:id+ backed endpoint to get payment status
    #
    # Redirects to either success or failure payments path
    #
    # ==== Path
    #     GET /payments/result
    #
    # ==== Params
    # * +payment_id+ - id of the created payment, required in the session
    # * +caz_id+ - id of the selected CAZ, required in the session
    def result
      payment_data = helpers.initiated_payment_data
      payment = Payments::Status.new(payment_data[:payment_id], payment_data[:caz_id])
      save_payment_details(payment)
      payment.success? ? redirect_to(success_payments_path) : redirect_to(failure_payments_path)
    end

    private

    # Saves payment details using SessionManipulation::SetPaymentDetails
    def save_payment_details(payment)
      SessionManipulation::SetPaymentDetails.call(session: session,
                                                  email: payment.user_email,
                                                  payment_reference: payment.payment_reference,
                                                  external_id: payment.external_id)
    end

    # Moves stored data to another key in session and stores new payment id
    def store_payment_data_in_session(response)
      store_params = { payment_id: response['paymentId'] }
      SessionManipulation::SetPaymentId.call(session: session, params: store_params)
      SessionManipulation::AddCurrentPayment.call(session: session)
    end

    # Checks if +new_payment_data+ present if not returns +initiated_payment_data+
    def payment_data
      helpers.new_payment_data[:caz_id] ? helpers.new_payment_data : helpers.initiated_payment_data
    end
  end
end
