# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the payment history, used in +app/views/payment_history/company_payment_history.html.haml+.
  #
  class Payment
    def initialize(data)
      @data = data.transform_keys { |key| key.underscore.to_sym }
    end

    # Returns payment id
    def payment_id
      data[:payment_id]
    end

    # Returns parsed payment date
    def date
      Date.parse(data[:payment_date]).strftime('%d/%m/%Y')
    end

    # Returns payment made by
    def payer_name
      data[:payer_name]
    end

    # Returns Clean Air Zone name
    def caz_name
      data[:caz_name]
    end

    # Returns count of entries
    def entries_count
      data[:entries_count]
    end

    # Returns amount paid
    def total_paid
      data[:total_paid]
    end

    # Returns a boolean, e.g. true
    def refunded?
      data[:is_refunded]
    end

    # Returns a boolean, e.g. true
    def charged_back?
      data[:is_chargedback]
    end

    private

    # Reader for data hash
    attr_accessor :data
  end
end
