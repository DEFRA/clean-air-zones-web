# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsApi.create_mandate - POST' do
  subject do
    DebitsApi.create_mandate(
      account_id: account_id,
      caz_id: SecureRandom.uuid,
      return_url: return_url,
      session_id: 'a724ed38b864e7490c91f9c06142ef9a',
      account_user_id: account_user_id
    )
  end

  let(:account_user_id) { SecureRandom.uuid }
  let(:account_id) { SecureRandom.uuid }
  let(:return_url) { 'http://ex.com/direct_debits/complete_setup?redirect_flow_id=RE0002VT8ZDTEM1PE4T8W730K' }
  let(:url) { "/payments/accounts/#{account_id}/direct-debit-mandates" }

  context 'when the response status is 201' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 201,
        body: read_unparsed_response('debits/create_mandate.json')
      )
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:post, /#{url}/)
    end

    it 'returns a proper attributes' do
      expect(subject.keys).to contain_exactly('nextUrl', 'cleanAirZoneId')
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, /#{url}/).to_return(status: 404, body: { message: 'Account id not found' }.to_json)
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
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
