# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.chargeable_vehicles' do
  subject do
    PaymentsApi.chargeable_vehicles(
      account_id: id,
      zone_id: zone_id,
      page: page,
      per_page: per_page,
      vrn: nil
    )
  end

  let(:id) { SecureRandom.uuid }
  let(:zone_id) { SecureRandom.uuid }
  let(:page) { 5 }
  let(:per_page) { 10 }
  let(:url) { "accounts/#{id}/chargeable-vehicles" }

  before do
    stub_request(:get, /#{url}/).to_return(
      status: 200,
      body: read_unparsed_response('payments/chargeable_vehicles.json')['1']
    )
  end

  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(
      :get,
      /#{url}\?cleanAirZoneId=#{zone_id}&pageNumber=#{page - 1}&pageSize=#{per_page}/
    )
  end
end
