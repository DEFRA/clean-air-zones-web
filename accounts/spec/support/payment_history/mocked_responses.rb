# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  module MockedResponses
    def mock_payment_history
      mock = instance_double(PaymentHistory::History, pagination: paginated_history(2))
      allow(PaymentHistory::History).to receive(:new).and_return(mock)
    end

    def mock_empty_payment_history
      mock = instance_double(PaymentHistory::History, pagination: empty_paginated_history)
      allow(PaymentHistory::History).to receive(:new).and_return(mock)
    end

    private

    def paginated_history(page = 1)
      instance_double(
        PaymentHistory::PaginatedPayment,
        payments_list: payments_list, page: page, total_pages: 5, range_start: 1, range_end: 10,
        total_payments_count: 52, results_per_page: [10, 20, 30, 40, 50]
      )
    end

    def empty_paginated_history
      instance_double(
        PaymentHistory::PaginatedPayment,
        payments_list: [], page: 0, total_pages: 0, range_start: 1, range_end: 10,
        total_payments_count: 0, results_per_page: [10, 20, 30, 40, 50]
      )
    end

    def payments_list
      api_response.map { |data| PaymentHistory::Payment.new(data) }
    end

    def api_response
      read_response('payment_history/payments.json')['1']['payments']
    end
  end
end
