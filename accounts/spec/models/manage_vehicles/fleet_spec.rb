# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::Fleet, type: :model do
  subject { described_class.new(account_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:vrn) { 'ABC123' }

  describe '.pagination' do
    subject(:vehicles) { described_class.new(account_id).pagination(page: page) }

    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:vehicles_data) { read_response('vehicles.json')[page.to_s] }

    before { allow(FleetsApi).to receive(:vehicles).and_return(vehicles_data) }

    it 'calls FleetsApi.vehicles with proper params' do
      vehicles
      expect(FleetsApi).to(have_received(:vehicles).with(
                             account_id: account_id,
                             page: page,
                             per_page: per_page,
                             only_chargeable: false,
                             vrn: nil
                           ))
    end

    it 'returns a VehiclesManagement::PaginatedFleet' do
      expect(subject).to be_a(VehiclesManagement::PaginatedFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of vehicles' do
        expect(subject.vehicle_list).to all(be_a(VehiclesManagement::Vehicle))
      end
    end

    describe '.total_pages' do
      it 'returns the total pages count value' do
        expect(subject.total_pages).to eq(vehicles_data['pageCount'])
      end
    end
  end

  describe '.add_vehicle' do
    subject { described_class.new(account_id).add_vehicle(vrn, vehicle_type) }

    let(:vehicle_type) { 'car' }

    context 'when api returns a proper status' do
      before { allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true) }

      it 'calls AccountsApi.vehicles with proper params' do
        subject
        expect(FleetsApi).to have_received(:add_vehicle_to_fleet)
          .with(vrn: vrn, vehicle_type: vehicle_type, account_id: account_id)
      end
    end

    context 'when api returns 422 status' do
      before do
        allow(FleetsApi).to receive(:add_vehicle_to_fleet)
          .and_raise(BaseApi::Error422Exception.new(422, '', {}))
      end

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.empty?' do
    let(:vehicles_data) { read_response('vehicles.json')['1'] }

    before { allow(FleetsApi).to receive(:vehicles).and_return(vehicles_data) }

    it 'calls AccountsApi.vehicles with proper params' do
      subject.empty?
      expect(FleetsApi).to have_received(:vehicles).with(account_id: account_id, page: 1, per_page: 1)
    end

    context 'when some vehicles returned' do
      it 'returns false' do
        expect(subject).not_to be_empty
      end
    end

    context 'when no vehicles returned' do
      let(:vehicles_data) { { 'vehicles' => [] } }

      it 'returns true' do
        expect(subject).to be_empty
      end
    end
  end

  describe '.any_undetermined_vehicles' do
    before { allow(FleetsApi).to receive(:vehicles).and_return(vehicles_data) }

    context 'when the are no undetermined vehicles' do
      let(:vehicles_data) { read_response('vehicles.json')['1'] }

      it 'returns false' do
        expect(subject.any_undetermined_vehicles).to eq(false)
      end
    end

    context 'when some vehicles are undetermined' do
      let(:vehicles_data) { read_response('vehicles.json')['2'] }

      it 'returns true' do
        expect(subject.any_undetermined_vehicles).to eq(true)
      end
    end
  end

  describe '.delete_vehicle' do
    before { allow(FleetsApi).to receive(:remove_vehicle_from_fleet).and_return(true) }

    it 'calls FleetsApi.remove_vehicle_from_fleet with proper params' do
      subject.delete_vehicle(vrn)
      expect(FleetsApi).to have_received(:remove_vehicle_from_fleet).with(account_id: account_id, vrn: vrn)
    end
  end

  describe '.total_vehicles_count' do
    let(:vehicles_data) { read_response('vehicles.json')['1'] }

    before { allow(FleetsApi).to receive(:vehicles).and_return(vehicles_data) }

    it 'calls AccountsApi.vehicles with proper params' do
      subject.total_vehicles_count
      expect(FleetsApi).to have_received(:vehicles).with(account_id: account_id, page: 1, per_page: 1)
    end

    context 'when some vehicles returned' do
      it 'returns vehicles count' do
        expect(subject.total_vehicles_count).to eq(12)
      end
    end
  end
end
