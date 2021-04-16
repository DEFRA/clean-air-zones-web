# frozen_string_literal: true

require 'rails_helper'

describe 'WhitelistApi.csv_exports' do
  subject { WhitelistApi.csv_exports }

  context 'when call returns 201' do
    before do
      csv_exports = file_fixture('responses/csv_exports.json').read
      stub_request(:post, /csv-exports/).to_return(status: 201, body: csv_exports)
    end

    it 'returns proper url' do
      url = 'https://s3.eu-west-2.amazonaws.com/csv-export-bucket/generated-file.csv'
      expect(subject).to eq(url)
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:post, /csv-exports/).to_return(
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
      stub_request(:post, /csv-exports/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises `Error400Exception`' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end
end
