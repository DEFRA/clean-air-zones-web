# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.payment_status' do
  subject { PaymentsApi.payment_status(payment_id: id, caz_name: 'leeds') }

  let(:id) { @uuid }

  context 'when the response status is 200' do
    before do
      stub_request(:put, /payments/).to_return(
        status: 200,
        body: {
          paymentId: id,
          status: 'success',
          userEmail: 'test@email.com'
        }.to_json
      )
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly('paymentId', 'status', 'userEmail')
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:put, /payments/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
