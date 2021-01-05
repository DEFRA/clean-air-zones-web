# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.add_vehicle_to_fleet' do
  subject { FleetsApi.add_vehicle_to_fleet(account_id: id, vehicle_type: vehicle_type, vrn: @vrn) }
  let(:id) { @uuid }
  let(:vehicle_type) { 'Car' }
  let(:url) { %r{accounts/#{id}/vehicles} }

  before do
    stub_request(:post, url).to_return(
      status: 200,
      body: '{}'
    )
  end

  it 'calls API with proper query data' do
    subject
    expect(WebMock)
      .to have_requested(:post, url)
      .with(body: { vrn: @vrn, cazVehicleType: vehicle_type })
  end

  it 'returns true' do
    expect(subject).to be_truthy
  end
end
