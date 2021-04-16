# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsApi.complete_mandate_creation - POST' do
  subject { DebitsApi.complete_mandate_creation(flow_id: flow_id, session_id: session_id, caz_id: caz_id) }

  let(:flow_id) { 'RE0002VT8ZDTEM1PE4T8W730KBDFH54X' }
  let(:session_id) { 'a724ed38b864e7490c91f9c06142ef9a' }
  let(:caz_id) { SecureRandom.uuid }
  let(:url) { "/payments/direct_debit_redirect_flows/#{flow_id}/complete" }

  context 'when the response status is 201' do
    before { stub_request(:post, /#{url}/).to_return(status: 201) }

    it 'calls API with proper body' do
      subject
      body = { sessionToken: session_id, cleanAirZoneId: caz_id }
      expect(WebMock).to have_requested(:post, /#{url}/).with(body: body).once
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
      stub_request(:post, /#{url}/).to_return(status: 500, body: { message: 'Something went wrong' }.to_json)
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
