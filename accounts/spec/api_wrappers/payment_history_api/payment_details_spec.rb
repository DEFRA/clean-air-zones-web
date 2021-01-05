# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistoryApi.payments' do
  subject { PaymentHistoryApi.payment_details(payment_id: payment_id) }

  let(:payment_id) { @uuid }
  let(:url) { %r{payments/#{payment_id}} }

  context 'when the response status is 200' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 200,
        body: read_unparsed_response('/payment_history/payment_details.json')
      )
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:get, url)
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly(
        'centralPaymentReference',
        'paymentProviderId',
        'paymentDate',
        'totalPaid',
        'telephonePayment',
        'payerName',
        'lineItems'
      )
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:get, /#{url}/).to_return(status: 404, body: { message: 'Account id not found' }.to_json)
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
