# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.job_status' do
  subject { FleetsApi.job_status(job_id: job_id, correlation_id: id) }
  let(:url) { %r{accounts/register-csv-from-s3/jobs/#{job_id}} }
  let(:id) { @uuid }
  let(:job_id) { @uuid }
  let(:status) { 'SUCCESS' }
  let(:errors) { ['Invalid VRN'] }

  context 'when the response status is 200' do
    before do
      stub_request(:get, url)
        .to_return(status: 200, body: { 'status' => status, 'errors' => errors }.to_json)
    end

    it 'calls API with correlation ID in headers' do
      subject
      expect(WebMock).to(
        have_requested(:get, url).with { |req| req.headers['X-Correlation-Id'] == id }.once
      )
    end

    it 'returns job status' do
      expect(subject[:status]).to eq(status)
    end

    it 'returns job errors' do
      expect(subject[:errors]).to eq(errors)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:get, url).to_return(
        status: 500,
        body: { message: 'Internal error' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
