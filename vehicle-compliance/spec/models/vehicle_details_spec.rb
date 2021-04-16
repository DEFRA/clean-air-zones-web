# frozen_string_literal: true

require 'rails_helper'

describe VehicleDetails, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }
  let(:type) { 'Car' }
  let(:response) do
    {
      'registrationNumber' => vrn,
      'type' => type,
      'make' => 'peugeot',
      'model' => '208',
      'colour' => 'grey',
      'fuelType' => 'diesel',
      'taxiOrPhv' => 'false'
    }
  end

  before { allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(response) }

  describe '.registration_number' do
    it 'returns a proper registration number' do
      expect(subject.registration_number).to eq(vrn)
    end
  end

  describe '.make' do
    it 'returns a proper type' do
      expect(subject.make).to eq('Peugeot')
    end
  end

  describe '.type' do
    it 'returns a proper type' do
      expect(subject.type).to eq('Car')
    end
  end

  describe '.colour' do
    it 'returns a proper colour' do
      expect(subject.colour).to eq('Grey')
    end
  end

  describe '.fuel_type' do
    it 'returns a proper fuel type' do
      expect(subject.fuel_type).to eq('Diesel')
    end
  end

  describe '.exempt?' do
    describe 'when key is not present' do
      it 'returns a nil' do
        expect(subject.exempt?).to eq(nil)
      end
    end

    describe 'when key is present' do
      before { allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return('exempt' => true) }

      it 'returns a true' do
        expect(subject.exempt?).to eq(true)
      end
    end
  end

  describe '.model' do
    it 'returns a proper model' do
      expect(subject.model).to eq('208')
    end
  end
end
