# frozen_string_literal: true

require 'rails_helper'

describe Payments::MakeDebitPayment do
  subject do
    described_class.call(
      payment_data: payment_data,
      account_id: account_id,
      user_id: user_id,
      user_email: user_email,
      mandate_id: mandate_id
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
  let(:caz_id) { '2b01a50b-72c0-48cc-bce2-136baac42581' }
  let(:account_id) { '1f30838f-69ee-4486-95b4-7dfcd5c6c67c' }
  let(:user_id) { 'cd319616-ae7d-43f8-87c9-e219252b589a' }
  let(:user_email) { 'test@email.com' }
  let(:mandate_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' }
  let(:transformed_data) do
    {
      caz_id: caz_id,
      account_id: account_id,
      user_id: user_id,
      user_email: user_email,
      mandate_id: mandate_id,
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
      allow(DebitsApi).to receive(:create_payment)
        .with(transformed_data)
        .and_return(read_response('/debits/create_payment.json'))
    end

    it 'calls DebitsApi#create_payment with transformed parameters' do
      subject
      expect(DebitsApi).to have_received(:create_payment).with(transformed_data)
    end
  end
end
