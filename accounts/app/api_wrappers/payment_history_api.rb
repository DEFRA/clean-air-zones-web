# frozen_string_literal: true

##
# API wrapper for connecting to PaymentsApi.
# Wraps methods regarding payment history.
# See {PaymentsApi}[rdoc-ref:PaymentsApi] for user related actions.
#
class PaymentHistoryApi < PaymentsApi
  class << self
    ##
    # Calls +/v1/accounts/:accountId/payments+ endpoint with +GET+ method and returns payment history
    #
    # ==== Attributes
    #
    # * +account_id+ - uuid, id of the account
    # * +user_id+ - uuid, ID of the user
    # * +user_payments+ - boolean, to filter out company payments and show only users payments
    # * +page+ - requested page of the results
    # * +per_page+ - number of payments per page, defaults to 10
    #
    # ==== Result
    #
    # Returned payment history will have the following fields:
    # * +payments+ - list of payment history
    # * +perPage+ - requested per_page value
    # * +page+ - requested page value
    # * +pageCount+ - number of available pages
    # * +totalPaymentsCount+ - total number of payment histories
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def payments(account_id:, user_id:, user_payments:, per_page:, page: 1)
      log_action('Getting payments history')
      query = { 'pageNumber' => calculate_page_number(page), 'pageSize' => per_page }
      query.merge!('accountUserId' => user_id) if user_payments
      request(:get, "/accounts/#{account_id}/payments", query: query)
    end

    ##
    # Calls +/v1/payments/:paymentId+ endpoint with +GET+ method and returns detailed payment history
    #
    # ==== Attributes
    #
    # * +payment_id+ - uuid, id of payment
    #
    # ==== Result
    #
    # Returned payment history will have the following fields:
    # * +payerName+ - payment made by
    # * +centralPaymentReference+ - unique traceability identifier
    # * +paymentDate+ - payment date
    # * +paymentProviderId+ - id of provider
    # * +totalPaid+ - amount of payment
    # * +telephonePayment+ - status of payment
    # * +lineItems+ - array of objects, history of payments for current payment reference
    #   * +vrn+ - string, vrn number
    #   * +caseReference+ - integer, central reference number of the payment
    #   * +paymentStatus+ - status of payment, e.g. 'paid'
    #   * +chargePaid+ - integer, total charge paid
    #   * +travelDate+ - string, payment date format
    # * +modificationHistory+ - refund or chargeback information
    #   * +amount+ integer, charge paid
    #   * +travelDate+ - string, date format
    #   * +vrn+ - string, eg. 'CU57ABC'
    #   * +caseReference+ - integer, central reference number of the payment
    #   * +modificationTimestamp+ - string, payment date format in UTC time
    #   * +entrantPaymentStatus+ - string, payment status e.g 'CHARGEBACK' or 'REFUNDED'
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - payment not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def payment_details(payment_id:)
      log_action('Getting payment history')
      request(:get, "/payments/#{payment_id}")
    end
  end
end
