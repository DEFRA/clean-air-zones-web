# frozen_string_literal: true

require 'rails_helper'

describe Payments::ChargeableVehicles, type: :model do
  subject { described_class.new(account_id, zone_id).pagination(page: page) }

  let(:account_id) { SecureRandom.uuid }
  let(:zone_id) { SecureRandom.uuid }

  describe '.pagination' do
    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:vehicles_data) { read_response('payments/chargeable_vehicles.json')[page.to_s] }

    before { allow(PaymentsApi).to receive(:chargeable_vehicles).and_return(vehicles_data) }

    it 'calls PaymentsApi.chargeable_vehicles with proper params' do
      subject
      expect(PaymentsApi).to(have_received(:chargeable_vehicles).with(
                               account_id: account_id,
                               zone_id: zone_id,
                               page: page,
                               per_page: per_page,
                               vrn: nil
                             ))
    end

    it 'returns Payments::PaginatedVehicles' do
      expect(subject).to be_a(Payments::PaginatedVehicles)
    end
  end
end
