# frozen_string_literal: true

require 'rails_helper'

describe ComplianceDetails, type: :model do
  subject { described_class.new(details, false) }

  let(:details) do
    {
      'name' => name,
      'operatorName' => operator_name,
      'charge' => charge,
      'informationUrls' => {
        'boundary' => url,
        'mainInfo' => url,
        'publicTransportOptions' => url,
        'exemptionOrDiscount' => url,
        'becomeCompliant' => url
      }
    }
  end

  let(:name) { 'Birmingham' }
  let(:operator_name) { 'Birmingham City Council' }
  let(:charge) { 5.1 }
  let(:url) { 'www.example.com' }

  describe '.zone_name' do
    it 'returns a proper name' do
      expect(subject.zone_name).to eq(name)
    end
  end

  describe '.charge' do
    it 'return proper string with charge' do
      expect(subject.charge).to eq('£5.10')
    end
  end

  describe '.charged?' do
    context 'when charge is above 0' do
      it 'returns true' do
        expect(subject).to be_charged
      end
    end

    context 'when charge is 0' do
      let(:charge) { 0 }

      it 'returns false' do
        expect(subject).not_to be_charged
      end
    end
  end

  describe '.main_info_url' do
    it 'returns a proper url' do
      expect(subject.main_info_url).to eq(url)
    end
  end

  describe '.public_transport_options_url' do
    it 'returns a proper url' do
      expect(subject.public_transport_options_url).to eq(url)
    end
  end

  describe '.exemption_or_discount_url' do
    it 'returns a proper url' do
      expect(subject.exemption_or_discount_url).to eq(url)
    end
  end

  describe '.become_compliant_url' do
    it 'returns a proper url' do
      expect(subject.become_compliant_url).to eq(url)
    end
  end

  describe '.boundary_url' do
    it 'returns a proper url' do
      expect(subject.boundary_url).to eq(url)
    end
  end

  describe '.operator_name' do
    it 'returns a proper value' do
      expect(subject.operator_name).to eq(operator_name)
    end
  end
end
