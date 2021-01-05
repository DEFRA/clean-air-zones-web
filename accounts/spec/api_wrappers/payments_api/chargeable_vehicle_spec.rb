# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.chargeable_vehicle' do
  subject { PaymentsApi.chargeable_vehicle(account_id: id, zone_id: zone_id, vrn: vrn) }

  let(:id) { @uuid }
  let(:zone_id) { @uuid }
  let(:vrn) { 'PAY001' }
  let(:url) { "accounts/#{id}/chargeable-vehicles/#{vrn}" }

  before do
    stub_request(:get, /#{url}/).to_return(
      status: 200,
      body: read_unparsed_response('chargeable_vehicle.json')
    )
  end

  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(:get, /#{url}\?cleanAirZoneId=#{zone_id}/)
  end
end
