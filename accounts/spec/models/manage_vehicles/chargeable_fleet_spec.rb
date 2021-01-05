# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::ChargeableFleet, type: :model do
  subject { described_class.new(data) }

  let(:first_vrn) { vehicles_data.first.try(:[], 'vrn') }
  let(:last_vrn) { vehicles_data.last.try(:[], 'vrn') }
  let(:vehicles_data) { read_response('chargeable_vehicles.json')['chargeableAccountVehicles']['results'] }

  let(:data) do
    {
      'chargeableAccountVehicles' => { 'results' => vehicles_data },
      'firstVrn' => first_vrn,
      'lastVrn' => last_vrn
    }
  end

  describe '.vehicle_list' do
    it 'returns an array of VehiclesManagement::ChargeableVehicle instances' do
      expect(subject.vehicle_list).to all(be_a(VehiclesManagement::ChargeableVehicle))
    end

    it 'returns a proper number of vehicles' do
      expect(subject.vehicle_list.size).to eq(vehicles_data.size)
    end
  end

  describe '.first_vrn' do
    it { expect(subject.first_vrn).to eq(first_vrn) }
  end

  describe '.last_vrn' do
    it { expect(subject.last_vrn).to eq(last_vrn) }
  end

  describe '.previous_page?' do
    it { expect(subject.previous_page?).to be_truthy }

    context 'without first_vrn' do
      let(:first_vrn) { nil }

      it { expect(subject.previous_page?).to be_falsey }
    end
  end

  describe '.next_page?' do
    it { expect(subject.next_page?).to be_truthy }

    context 'without last_vrn' do
      let(:last_vrn) { nil }

      it { expect(subject.next_page?).to be_falsey }
    end
  end

  describe '.all_dates_unpaid?' do
    context 'not all days are unpaid' do
      it 'returns false' do
        expect(subject.all_days_unpaid?).to be_falsey
      end
    end

    context 'all days are unpaid' do
      let(:vehicles_data) do
        response = read_response('chargeable_vehicles_with_unpaid_dates.json')
        response['chargeableAccountVehicles']['results']
      end

      it 'returns true' do
        expect(subject.all_days_unpaid?).to be_truthy
      end
    end
  end

  describe '.any_results?' do
    it { expect(subject.any_results?).to be_truthy }

    context 'without any results' do
      let(:vehicles_data) { [] }

      it { expect(subject.any_results?).to be_falsey }
    end
  end
end
