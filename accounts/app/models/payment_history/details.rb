# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the detailed payment history
  #
  class Details
    # Initializer method.
    #
    # ==== Params
    # * +payment_id+ - Payment ID from backend DB
    #
    def initialize(payment_id)
      @payment_id = payment_id
    end

    # Returns a sorted by vrn PaymentHistory::DetailsPayment with payments associated with the account
    def payments
      result = api_call['lineItems'].group_by { |key| key['vrn'] }
      result.map { |payment| PaymentHistory::DetailsPayment.new(vrn: payment.first, items: payment.second) }
    end

    # payment made by
    def payer_name
      api_call['payerName']
    end

    # date of payment, e.g.'Sunday 26 July 2020'
    def date
      Date.parse(api_call['paymentDate']).strftime('%A %d %B %Y')
    end

    # payment reference number
    def reference
      api_call['centralPaymentReference']
    end

    # provider payment id
    def provider_payment_id
      api_call['paymentProviderId']
    end

    private

    # Reader for Payment ID from backend DB
    attr_reader :payment_id

    # Calls the api go get all payment details
    def api_call
      @api_call ||= PaymentHistoryApi.payment_details(payment_id: payment_id)
    end
  end
end
