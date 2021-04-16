# frozen_string_literal: true

require 'rails_helper'

describe Payments::MakeCardPayment do
  subject do
    described_class.call(
      payment_data: payment_data,
      user_id: user_id,
      return_url: return_url
    )
  end

  let(:charge_in_pounds) { 50.0 }
  let(:payment_data) do
    {
      caz_id: caz_id,
      details: {
        'PAY015' => {
          vrn: 'PAY015',
          tariff: 'BCC01-HEAVY GOODS VEHICLE',
          charge: charge_in_pounds,
          dates: ['2020-03-04']
        }
      }
    }
  end

  let(:return_url) { 'http://example.com' }
  let(:caz_id) { '2b01a50b-72c0-48cc-bce2-136baac42581' }
  let(:user_id) { 'cd319616-ae7d-43f8-87c9-e219252b589a' }

  let(:transformed_data) do
    {
      caz_id: caz_id,
      return_url: return_url,
      user_id: user_id,
      transactions: [
        {
          vrn: 'PAY015',
          charge: charge_in_pounds * 100, # charge in pence
          travel_date: '2020-03-04',
          tariff_code: 'BCC01-HEAVY GOODS VEHICLE'
        }
      ]
    }
  end

  describe '#call' do
    before do
      allow(PaymentsApi).to receive(:create_payment)
        .with(transformed_data)
        .and_return(nextUrl: 'http://example.com')
    end

    it 'calls PaymentsApi#create_payment with transformed parameters' do
      subject
      expect(PaymentsApi).to have_received(:create_payment).with(transformed_data)
    end
  end
end
