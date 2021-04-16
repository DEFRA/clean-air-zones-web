# frozen_string_literal: true

require 'rails_helper'

describe Compliance, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'CU1234' }
  let(:compliance_response) { read_response('vehicle_compliance_response.json') }

  before { allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance_response) }

  describe '.compliance_outcomes' do
    let(:outcomes) { subject.compliance_outcomes }

    it 'calls ComplianceCheckerApi' do
      outcomes
      expect(ComplianceCheckerApi).to have_received(:vehicle_compliance).with(vrn)
    end

    it 'returns an array of ComplianceDetails' do
      expect(outcomes).to all(be_an(ComplianceDetails))
    end
  end

  describe '.any_caz_chargeable?' do
    let(:any_caz_chargeable) { subject.any_caz_chargeable? }

    it 'calls ComplianceCheckerApi' do
      any_caz_chargeable
      expect(ComplianceCheckerApi).to have_received(:vehicle_compliance).with(vrn)
    end

    context 'when subject details has chargeable CAZ' do
      it 'returns true' do
        expect(any_caz_chargeable).to eq(true)
      end
    end

    context 'when subject details has no chargeable CAZ' do
      let(:compliance_response) { read_response('non_chargeable_vehicle_compliance_response.json') }

      it 'returns false' do
        expect(any_caz_chargeable).to eq(false)
      end
    end
  end

  describe '.phgv_discount_available?' do
    let(:phgv_discount_available) { subject.phgv_discount_available? }

    it 'calls ComplianceCheckerApi' do
      phgv_discount_available
      expect(ComplianceCheckerApi).to have_received(:vehicle_compliance).with(vrn)
    end

    context 'when PHGV discount is available' do
      it 'returns true' do
        expect(phgv_discount_available).to eq(true)
      end
    end

    context 'when PHGV discount is not available' do
      let(:compliance_response) do
        read_response('phgv_discount_not_available_vehicle_compliance_response.json')
      end

      it 'returns false' do
        expect(phgv_discount_available).to eq(false)
      end
    end
  end
end
