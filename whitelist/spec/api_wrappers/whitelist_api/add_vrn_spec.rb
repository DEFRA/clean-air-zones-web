# frozen_string_literal: true

require 'rails_helper'

describe 'WhitelistApi.vrn_details' do
  subject { WhitelistApi.add_vrn(vrn_details, new_user) }

  let(:vrn_details) { { vrn: 'CU57ABC', category: 'Early Adopter', reason: 'Testing' } }

  context 'when the response status is 201' do
    before do
      vrn_details = file_fixture('responses/vrn_details_response.json').read
      stub_request(:post, /vehicles/).to_return(status: 201, body: vrn_details)
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
      stub_request(:post, /vehicles/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises `Error500Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:post, /vehicles/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises `Error400Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 422' do
    before do
      stub_request(:post, /vehicles/).to_return(
        status: 422,
        body: { 'message' => 'CU57ABC is an invalid registration number' }.to_json
      )
    end

    it 'raises `Error422Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
