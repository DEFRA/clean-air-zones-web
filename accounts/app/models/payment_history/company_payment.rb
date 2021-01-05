# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the payment history, used in +app/views/payment_history/company_payment_history.html.haml+.
  #
  class CompanyPayment
    def initialize(data)
      @data = data.transform_keys { |key| key.underscore.to_sym }
    end

    # payment id
    def payment_id
      data[:payment_id]
    end

    # parsed payment date
    def date
      Date.parse(data[:payment_date]).strftime('%d/%m/%Y')
    end

    # payment made by
    def payer_name
      data[:payer_name]
    end

    # Clean Air Zone name
    def caz_name
      data[:caz_name]
    end

    # count of entries
    def entries_count
      data[:entries_count]
    end

    # amount paid
    def total_paid
      data[:total_paid]
    end

    private

    # Reader for data hash
    attr_accessor :data
  end
end
