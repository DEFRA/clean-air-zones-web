# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComplianceDetails, type: :model do
  subject(:compliance) { described_class.new(details) }

  let(:details) do
    {
      'name' => name,
      'charge' => charge,
      'informationUrls' => {
        'boundary' => url,
        'emissionsStandards' => url,
        'mainInfo' => url,
        'pricing' => url,
        'hoursOfOperation' => url,
        'exemptionOrDiscount' => url,
        'payCaz' => url,
        'becomeCompliant' => url,
        'financialAssistance' => url
      }
    }
  end

  let(:name) { 'Birmingham' }
  let(:charge) { 5.1 }
  let(:url) { 'www.example.com' }

  describe '.zone_name' do
    it 'returns a proper name' do
      expect(compliance.zone_name).to eq(name)
    end
  end

  describe '.charge' do
    it 'return proper string with charge' do
      expect(compliance.charge).to eq('£5.10')
    end
  end

  describe '.charged?' do
    context 'when charge is above 0' do
      it 'returns true' do
        expect(compliance).to be_charged
      end
    end

    context 'when charge is 0' do
      let(:charge) { 0 }

      it 'returns false' do
        expect(compliance).not_to be_charged
      end
    end
  end

  describe '.main_info_url' do
    it 'returns a proper url' do
      expect(compliance.main_info_url).to eq(url)
    end
  end

  describe '.emissions_standards_url' do
    it 'returns a proper url' do
      expect(compliance.emissions_standards_url).to eq(url)
    end
  end

  describe '.pricing_url' do
    it 'returns a proper url' do
      expect(compliance.pricing_url).to eq(url)
    end
  end

  describe '.hours_of_operation_url' do
    it 'returns a proper url' do
      expect(compliance.hours_of_operation_url).to eq(url)
    end
  end

  describe '.exemption_or_discount_url' do
    it 'returns a proper url' do
      expect(compliance.exemption_or_discount_url).to eq(url)
    end
  end

  describe '.pay_caz_url' do
    it 'returns a proper url' do
      expect(compliance.pay_caz_url).to eq(url)
    end
  end

  describe '.become_compliant_url' do
    it 'returns a proper url' do
      expect(compliance.become_compliant_url).to eq(url)
    end
  end

  describe '.financial_assistance_url' do
    it 'returns a proper url' do
      expect(compliance.financial_assistance_url).to eq(url)
    end
  end

  describe '.boundary_url' do
    it 'returns a proper url' do
      expect(compliance.boundary_url).to eq(url)
    end
  end
end
