# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsApi.create_payment - POST' do
  subject do
    DebitsApi.create_payment(
      caz_id: caz_id,
      account_id: account_id,
      user_id: user_id,
      mandate_id: mandate_id,
      user_email: user_email,
      transactions: transactions
    )
  end

  let(:user) { create_user }
  let(:caz_id) { @uuid }
  let(:account_id) { user.account_id }
  let(:user_id) { user.user_id }
  let(:mandate_id) { SecureRandom.uuid }
  let(:user_email) { user.email }
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
  let(:url) { '/v1/direct-debit-payments' }

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
                accountId: account_id,
                cleanAirZoneId: caz_id,
                userId: user_id,
                userEmail: user_email,
                mandateId: mandate_id,
                transactions: transactions
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
