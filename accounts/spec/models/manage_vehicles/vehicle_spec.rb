# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::Vehicle, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      'vrn' => vrn,
      'vehicleType' => type,
      'cachedCharges' => [
        { 'cazId' => caz_id, 'charge' => charge, 'tariffCode' => 'VAN-123' }
      ]
    }
  end

  let(:caz_id) { @uuid }
  let(:vrn) { 'CAS310' }
  let(:type) { 'type' }
  let(:charge) { 12 }

  describe '.vrn' do
    it 'returns VRN' do
      expect(subject.vrn).to eq(vrn)
    end
  end

  describe '.type' do
    it 'returns humanized type' do
      expect(subject.type).to eq(type.humanize)
    end

    context 'when there is no type' do
      let(:type) { nil }

      it 'returns Undetermined' do
        expect(subject.type).to eq('Undetermined')
      end
    end
  end

  describe '.charge' do
    it 'returns charge value as float' do
      expect(subject.charge(caz_id)).to eq(charge.to_f)
    end

    context 'when unknown CAZ given' do
      it 'returns nil' do
        expect(subject.charge('test')).to be_nil
      end
    end

    context 'when charge is null' do
      let(:charge) { nil }

      it 'returns nil' do
        expect(subject.charge(caz_id)).to be_nil
      end
    end
  end

  describe '.formatted_charge' do
    context 'when charge is in full pounds' do
      let(:charge) { 8 }

      it 'returns formatted charge value without pence' do
        expect(subject.formatted_charge(caz_id)).to eq('£8')
      end
    end

    context 'when charge is not in full pounds' do
      let(:charge) { 8.5 }

      it 'returns formatted charge value with pence' do
        expect(subject.formatted_charge(caz_id)).to eq('£8.50')
      end
    end

    context 'when charge is 0' do
      let(:charge) { 0 }

      it "returns 'No charge'" do
        expect(subject.formatted_charge(caz_id)).to eq('No charge')
      end
    end

    context 'when charge is null' do
      let(:charge) { nil }

      it "returns 'Undetermined'" do
        expect(subject.formatted_charge(caz_id)).to eq('Undetermined')
      end
    end

    context 'when unknown CAZ given' do
      it "returns 'Undetermined'" do
        expect(subject.formatted_charge('test')).to eq('Undetermined')
      end
    end
  end
end
