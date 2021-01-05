# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.create_payment' do
  subject do
    PaymentsApi.create_payment(
      caz_id: caz_id,
      return_url: return_url,
      user_id: user_id,
      transactions: transactions
    )
  end

  let(:caz_id) { @uuid }
  let(:return_url) { 'http://example.com' }
  let(:user_id) { @uuid }
  let(:transactions) do
    [
      {
        vrn: vrn,
        travel_date: today,
        tariff_code: tariff_code,
        charge: charge
      }
    ]
  end

  let(:today) { Date.current.to_s }
  let(:vrn) { 'CAS134' }
  let(:tariff_code) { 'BCC01-private-car' }
  let(:charge) { 18 }
  let(:url) { '/v1/payments' }

  context 'when the response status is :created (201)' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 201,
        body: { 'paymentId': @uuid, 'nextUrl': 'http://example.com' }.to_json
      )
    end

    it 'returns a proper attributes' do
      expect(subject.keys).to contain_exactly('paymentId', 'nextUrl')
    end

    it 'calls API with right params' do
      expect(subject)
        .to have_requested(:post, /#{url}/)
        .with(body: {
                cleanAirZoneId: caz_id,
                returnUrl: return_url,
                userId: user_id,
                transactions: transactions,
                telephonePayment: false
              })
    end
  end

  context 'when the response status is :internal_server_error (500)' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
