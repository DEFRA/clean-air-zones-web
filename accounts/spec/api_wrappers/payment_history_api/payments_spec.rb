# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistoryApi.payments' do
  subject do
    PaymentHistoryApi.payments(
      account_id: account_id,
      user_id: user_id,
      user_payments: user_payments,
      page: page,
      per_page: per_page
    )
  end

  let(:account_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:user_payments) { true }
  let(:page) { 5 }
  let(:per_page) { 10 }
  let(:url) { %r{accounts/#{account_id}/payments\?accountUserId=#{user_id}&pageNumber=#{page - 1}} }

  context 'when the response status is 200' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 200,
        body: read_unparsed_response('/payment_history/payments.json')['1']
      )
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:get, url)
    end

    context 'with per_page' do
      let(:per_page) { 25 }

      it 'calls API with proper query data' do
        subject
        expect(WebMock).to have_requested(:get, url)
      end
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
