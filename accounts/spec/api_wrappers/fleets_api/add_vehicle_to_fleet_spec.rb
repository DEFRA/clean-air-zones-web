# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.add_vehicle_to_fleet' do
  subject { FleetsApi.add_vehicle_to_fleet(account_id: id, vehicle_type: vehicle_type, vrn: vrn) }

  let(:id) { SecureRandom.uuid }
  let(:vehicle_type) { 'Car' }
  let(:vrn) { 'ABC123' }
  let(:url) { %r{accounts/#{id}/vehicles} }

  before { stub_request(:post, url).to_return(status: 200, body: '{}') }

  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(:post, url).with(body: { vrn: vrn, cazVehicleType: vehicle_type })
  end

  it 'returns true' do
    expect(subject).to be_truthy
  end
end
