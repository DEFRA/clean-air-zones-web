# frozen_string_literal: true

require 'rails_helper'

describe 'ComplianceCheckerApi.vehicle_details' do
  subject { ComplianceCheckerApi.vehicle_details(vrn) }

  let(:vrn) { 'CU57ABC' }

  context 'when call returns 200' do
    before do
      vehicle_details = file_fixture('vehicle_details_response.json').read
      stub_request(:get, /details/).to_return(status: 200, body: vehicle_details)
    end

    it 'returns proper fields' do
      expect(subject.keys).to contain_exactly(
        'registrationNumber', 'type', 'make', 'model', 'colour', 'fuelType', 'taxiOrPhv'
      )
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:get, /details/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:get, /details/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises Error400Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 404' do
    before do
      stub_request(:get, /details/).to_return(
        status: 404,
        body: { 'message' => "Vehicle with registration number #{vrn} was not found" }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when call returns 422' do
    before do
      stub_request(:get, /details/).to_return(
        status: 422,
        body: { 'message' => "#{vrn} is an invalid registration number" }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end

  context 'when body is an invalid JSON format' do
    before { stub_request(:get, /details/).to_return(status: 200, body: body) }

    let(:body) { 'invalid JSON format' }

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(an_instance_of(BaseApi::Error500Exception)
        .and(having_attributes(status: 500, status_message: 'Response body parsing failed', body: body)))
    end
  end
end
