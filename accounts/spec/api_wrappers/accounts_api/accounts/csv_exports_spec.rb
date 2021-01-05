# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.csv_exports - POST' do
  subject { AccountsApi::Accounts.csv_exports(account_id: account_id) }

  let(:account_id) { @uuid }
  let(:url) { "/accounts/#{account_id}/vehicles/csv-exports" }

  context 'when call returns 201' do
    let(:file_url) { 'https://example.com/bucket-name/file.csv' }

    before do
      body = { fileUrl: file_url, bucketName: 'bucket-name' }.to_json
      stub_request(:post, /#{url}/).to_return(status: 201, body: body)
      subject
    end

    it 'calls API with proper body' do
      expect(WebMock).to have_requested(:post, /#{url}/).once
    end

    it 'returns a proper url' do
      expect(subject).to eq(file_url)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises `Error400Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises `Error500Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
