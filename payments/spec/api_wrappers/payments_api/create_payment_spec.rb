# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.create_payment' do
  subject { PaymentsApi.create_payment(zone_id: zone_id, return_url: return_url, transactions: transactions) }

  let(:vrn) { 'CU57ABC' }
  let(:charge) { 80 }
  let(:zone_id) { SecureRandom.uuid }
  let(:days) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:return_url) { 'www.wp.pl' }
  let(:tariff) { 'BCC01-private_car' }
  let(:transactions) do
    [
      {
        vrn: vrn,
        travelDate: days.first,
        tariffCode: tariff,
        charge: charge
      },
      {
        vrn: vrn,
        travelDate: days.last,
        tariffCode: tariff,
        charge: charge
      }
    ]
  end

  context 'when the response status is 200' do
    before do
      stub_request(:post, /payments/).to_return(
        status: 200,
        body: { 'paymentId' => SecureRandom.uuid, 'nextUrl' => 'www.wp.pl' }.to_json
      )
    end

    it 'returns proper fields' do
      expect(subject.keys).to contain_exactly('paymentId', 'nextUrl')
    end

    it 'calls API with right params' do
      expect(subject)
        .to have_requested(:post, /payments/)
        .with(body: {
                'transactions' => transactions,
                'cleanAirZoneId' => zone_id,
                'returnUrl' => return_url,
                'telephonePayment' => false
              })
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:post, /payments/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when body is an invalid JSON format' do
    before { stub_request(:post, /payments/).to_return(status: 200, body: body) }

    let(:body) { 'invalid JSON format' }

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(
        an_instance_of(BaseApi::Error500Exception)
          .and(having_attributes(
                 status: 500,
                 status_message: 'Response body parsing failed',
                 body: body
               ))
      )
    end
  end
end
