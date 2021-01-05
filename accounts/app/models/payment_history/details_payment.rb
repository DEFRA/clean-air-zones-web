# frozen_string_literal: true

##
# Module used for showing the payment history details
module PaymentHistory
  ##
  # Represents the virtual model of the payment history, used in +app/views/payment_history/payment_history_details.html.haml+.
  #
  class DetailsPayment
    # Attributes accessor
    attr_accessor :vrn

    ##
    # Initializer method
    #
    # ==== Attributes
    #
    # * +vrn+ - vehicle registration number, eg. 'CU57ABC'
    # * +items+ - array of objects
    #   * +caseReference+ - unique traceability identifier
    #   * +chargePaid+ - amount paid, e.g. 4.23
    #   * +paymentStatus+ - status of payment, e.g. 'paid'
    #   * +travelDate+ - dates of entry, e.g. '2020-07-31'
    #
    def initialize(vrn:, items:)
      @vrn = vrn
      @items = items
    end

    # Parsed array of dates, e.g. ['Sunday 26th July 2020', 'Wednesday 29th July 2020']
    def dates
      items.map { |key| key['travelDate'] }.map do |date|
        parsed_date = Date.parse(date)
        parsed_date.strftime("%A #{parsed_date.day.ordinalize} %B %Y")
      end
    end

    # sum of amount paid for all entries
    def total_paid
      items.map { |key| key['chargePaid'] }.sum
    end

    private

    # Reader for data hash
    attr_accessor :items
  end
end
