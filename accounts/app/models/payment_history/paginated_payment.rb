# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Class used to display payment history
  #
  class PaginatedPayment
    # Take data returned from the PaymentHistoryApi.payments
    def initialize(data)
      @data = data
    end

    # Returns an array of PaymentHistory::Payment model instances
    def payments_list
      @payments_list ||= data['payments'].map { |payment| PaymentHistory::Payment.new(payment) }
    end

    # Returns current page value
    def page
      data['page'] + 1
    end

    # Returns the number of available pages
    def total_pages
      data['pageCount']
    end

    # Returns the total number of payments in the history
    def total_payments_count
      data['totalPaymentsCount']
    end

    # Returns the number of payments displayed per page
    def per_page
      data['perPage']
    end

    # Returns the index of the first payment on the page
    def range_start
      page * per_page - (per_page - 1)
    end

    # Returns the index of the last payment on the page
    def range_end
      max = page * per_page
      max > total_payments_count ? total_payments_count : max
    end

    # Determinate how many per page options should show
    def results_per_page
      case total_payments_count
      when 11..20
        [10, 20]
      when 21..30
        [10, 20, 30]
      when 31..40
        [10, 20, 30, 40]
      else
        [10, 20, 30, 40, 50]
      end
    end

    private

    # Attributes reader
    attr_reader :data
  end
end
