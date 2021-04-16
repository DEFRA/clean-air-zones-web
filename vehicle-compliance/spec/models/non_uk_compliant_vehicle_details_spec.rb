# frozen_string_literal: true

require 'rails_helper'

describe NonUkCompliantVehicleDetails, type: :model do
  subject { described_class.new(caz_data) }

  let(:caz_data) do
    {
      'name' => name,
      'operatorName' => operator_name,
      'boundaryUrl' => boundary_url,
      'mainInfoUrl' => main_info_url,
      'exemptionUrl' => exemption_url
    }
  end

  let(:name) { 'Birmingham' }
  let(:operator_name) { 'Birmingham City Council' }
  let(:boundary_url) { 'www.example.com' }
  let(:main_info_url) { 'www.main.info' }
  let(:exemption_url) { 'www.exemption.co.uk' }

  describe '.zone_name' do
    it 'returns proper .zone_name value' do
      expect(subject.zone_name).to eq(name)
    end
  end

  describe '.charged?' do
    it 'returns proper .charged? value' do
      expect(subject.charged?).to eq(false)
    end
  end

  describe '.charge' do
    it 'returns proper .charge value' do
      expect(subject.charge).to eq(0)
    end
  end

  describe '.main_info_url' do
    it 'returns proper .main_info_url value' do
      expect(subject.main_info_url)
        .to eq(main_info_url)
    end
  end

  describe '.boundary_url' do
    it 'returns proper .boundary_url value' do
      expect(subject.boundary_url).to eq(boundary_url)
    end
  end

  describe '.exemption_or_discount_url' do
    it 'return proper .exemption_or_discount_url value' do
      expect(subject.exemption_or_discount_url).to eq(exemption_url)
    end
  end

  describe '.operator_name' do
    it 'returns a proper value' do
      expect(subject.operator_name).to eq(operator_name)
    end
  end
end
