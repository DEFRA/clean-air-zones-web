# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.register_job' do
  subject { FleetsApi.register_job(filename: filename, correlation_id: id, large_fleet: large_fleet) }

  let(:url) { %r{accounts/register-csv-from-s3/jobs} }
  let(:id) { SecureRandom.uuid }
  let(:filename) { 'filename' }
  let(:job_name) { SecureRandom.uuid }
  let(:large_fleet) { false }

  context 'when the response status is 200' do
    before { stub_request(:post, url).to_return(status: 200, body: { 'jobName' => job_name }.to_json) }

    it 'calls API with proper body' do
      subject
      expect(WebMock)
        .to have_requested(:post, url)
        .with(body: { filename: filename, s3Bucket: ENV['S3_AWS_BUCKET'], successEmail: large_fleet })
        .once
    end

    it 'calls API with correlation ID in headers' do
      subject
      expect(WebMock).to(have_requested(:post, url).with { |req| req.headers['X-Correlation-Id'] == id })
    end

    it 'returns job name' do
      expect(subject).to eq(job_name)
    end
  end

  context 'when the response status is 500' do
    before { stub_request(:post, url).to_return(status: 500, body: { message: 'Internal error' }.to_json) }

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
