# frozen_string_literal: true

# helper methods for make payments flow
module MockPayments
  def mock_requests_to_payments_api_with(return_url: '/')
    mock_payment_creation(return_url: return_url)
    mock_payment_status
  end

  def mock_payment_creation(return_url:)
    allow(PaymentsApi).to receive(:create_payment).and_return(
      'paymentId' => '294a5714-bf0f-4972-84cf-6ff6c967d22a',
      'nextUrl' => return_url
    )
  end

  def mock_payment_status
    payment_status_response = read_response('payment_status.json')
    allow(PaymentsApi).to receive(:payment_status).and_return(payment_status_response)
  end
end

World(MockPayments)
