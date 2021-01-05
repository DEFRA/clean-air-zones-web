# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::ChargeableVehicle, type: :model do
  subject { described_class.new(data) }

  let(:data) { { 'vrn' => vrn, 'charge' => charge, 'tariffCode' => tariff } }
  let(:caz_id) { @uuid }
  let(:vrn) { 'CAS310' }
  let(:tariff) { 'VAN-123' }
  let(:charge) { 12.0 }

  describe '.vrn' do
    it { expect(subject.vrn).to eq(vrn) }
  end

  describe '.charge' do
    it { expect(subject.charge).to eq(charge) }
  end

  describe '.tariff' do
    it { expect(subject.tariff).to eq(tariff) }
  end

  describe '.paid_dates' do
    it 'returns an empty array' do
      expect(subject.paid_dates).to eq([])
    end

    context 'with paidDates' do
      let(:dates) { ['2020-02-21'] }
      let(:data) { { 'paidDates' => dates } }

      it 'returns dates' do
        expect(subject.paid_dates).to eq(dates)
      end
    end
  end

  describe '.serialize' do
    it 'returns a proper hash' do
      expect(subject.serialize).to eq({ vrn: vrn, tariff: tariff, charge: charge, dates: [] })
    end
  end
end
