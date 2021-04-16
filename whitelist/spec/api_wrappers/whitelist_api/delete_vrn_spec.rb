# frozen_string_literal: true

require 'rails_helper'

describe 'WhitelistApi.delete_vrn' do
  subject { WhitelistApi.delete_vrn(vrn, user_uuid, 'user@example.com') }

  let(:user_uuid) { SecureRandom.uuid }

  context 'when the response status is 200' do
    before do
      vrn_details = file_fixture('responses/vrn_details_response.json').read
      stub_request(:delete, /vehicles/)
        .with(headers: { 'X-Modifier-ID' => user_uuid })
        .to_return(status: 200, body: vrn_details)
    end

    it 'returns proper fields' do
      expect(subject.keys).to contain_exactly(
        'vrn',
        'category',
        'manufacturer',
        'reasonUpdated',
        'email',
        'uploaderId',
        'updateTimestamp'
      )
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:delete, /vehicles/)
        .with(headers: { 'X-Modifier-ID' => user_uuid })
        .to_return(status: 500, body: { 'message' => 'Something went wrong' }.to_json)
    end

    it 'raises `Error500Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:delete, /vehicles/)
        .with(headers: { 'X-Modifier-ID' => user_uuid })
        .to_return(status: 400, body: { 'message' => 'Correlation ID is missing' }.to_json)
    end

    it 'raises `Error400Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 404' do
    before do
      stub_request(:delete, /CU57ABC/)
        .with(headers: { 'X-Modifier-ID' => user_uuid })
        .to_return(status: 404, body: { 'message' => "VRN #{vrn} was not found" }.to_json)
    end

    it 'raises `Error404Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end
end
