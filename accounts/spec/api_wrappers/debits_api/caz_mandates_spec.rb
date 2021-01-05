# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsApi.caz_mandates - GET' do
  subject { DebitsApi.caz_mandates(account_id: account_id, zone_id: zone_id) }

  let(:account_id) { @uuid }
  let(:zone_id) { @uuid }
  let(:url) { "payments/accounts/#{account_id}/direct-debit-mandates/#{zone_id}" }

  context 'when the response status is 200' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 200,
        body: read_unparsed_response('debits/caz_mandates.json')
      )
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(
        :get,
        /#{url}/
      )
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 404,
        body: { message: 'Account id not found' }.to_json
      )
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
