# frozen_string_literal: true

require 'rails_helper'

describe 'ComplianceCheckerApi.clean_air_zones' do
  subject { ComplianceCheckerApi.clean_air_zones }

  let(:url) { %r{v1/payments/clean-air-zones} }

  context 'when subject returns 200' do
    before do
      caz_list_response = read_unparsed_response('caz_list.json')
      stub_request(:get, url).to_return(
        status: 200,
        body: caz_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'returns an array of clear air zones' do
      expect(subject).to be_a(Array)
    end

    it 'returns a proper fields' do
      expect(subject.first.keys).to(
        contain_exactly('cleanAirZoneId', 'name', 'operatorName', 'boundaryUrl', 'activeChargeStartDate')
      )
    end

    it 'calls API once' do
      subject
      expect(WebMock).to have_requested(:get, url).once
    end
  end

  context 'when subject returns 500' do
    before do
      stub_request(:get, /clean-air-zones/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
