# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.chargeable_vehicles' do
  subject { PaymentsApi.chargeable_vehicles(account_id: id, zone_id: zone_id) }

  let(:id) { @uuid }
  let(:zone_id) { @uuid }
  let(:url) { "accounts/#{id}/chargeable-vehicles" }

  before do
    stub_request(:get, /#{url}/).to_return(
      status: 200,
      body: read_unparsed_response('chargeable_vehicles.json')
    )
  end

  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(
      :get,
      /#{url}\?cleanAirZoneId=#{zone_id}&pageSize=10/
    )
  end

  context 'with vrn and direction' do
    subject do
      PaymentsApi.chargeable_vehicles(
        account_id: id, zone_id: zone_id, vrn: @vrn, direction: direction
      )
    end

    let(:direction) { 'next' }

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(
        :get,
        /#{url}\?cleanAirZoneId=#{zone_id}&direction=#{direction}&pageSize=10&vrn=#{@vrn}/
      )
    end

    context 'when direction is missing' do
      let(:direction) { nil }

      it 'calls API without vrn and direction' do
        subject
        expect(WebMock).to have_requested(
          :get,
          /#{url}\?cleanAirZoneId=#{zone_id}&pageSize=10/
        )
      end
    end
  end
end
