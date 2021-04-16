# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  subject { create_user(account_id: account_id, user_id: user_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  describe '.fleet' do
    it 'returns a fleet object' do
      expect(subject.fleet).to be_a(VehiclesManagement::Fleet)
    end

    it 'calls VehiclesManagement::Fleet.new with proper params' do
      allow(VehiclesManagement::Fleet).to receive(:new)
      subject.fleet
      expect(VehiclesManagement::Fleet).to have_received(:new).with(account_id)
    end
  end

  describe '.add_vehicle' do
    let(:vrn) { mocked_vrn }
    let(:vehicle_type) { 'car' }

    it 'calls FleetsApi.add_vehicle_to_fleet with proper params' do
      allow(FleetsApi).to receive(:add_vehicle_to_fleet)
      subject.add_vehicle(vrn, vehicle_type)
      expect(FleetsApi).to have_received(:add_vehicle_to_fleet).with(
        vrn: vrn,
        vehicle_type: vehicle_type,
        account_id: account_id
      )
    end
  end

  describe '.actual_account_name' do
    before { allow(AccountsApi::Users).to receive(:account_details).and_return('accountName' => 'Acc Name') }

    it 'calls AccountsApi::Users.account_details with proper params' do
      subject.actual_account_name
      expect(AccountsApi::Users).to have_received(:account_details).with(account_user_id: user_id)
    end

    it 'returns correct value' do
      expect(subject.actual_account_name).to eq('Acc Name')
    end
  end
end
