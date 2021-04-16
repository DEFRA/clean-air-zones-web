# frozen_string_literal: true

require 'rails_helper'

describe CleanAirZone, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      name: name,
      operatorName: operator_name,
      cleanAirZoneId: id,
      boundaryUrl: url,
      exemptionUrl: url,
      activeChargeStartDate: active_charge_start_date
    }.stringify_keys
  end
  let(:name) { 'Birmingham' }
  let(:operator_name) { 'Bath and North East Somerset Council' }
  let(:id) { 'a49afb83-d1b3-48b6-b08b-5db8142045dc' }
  let(:url) { 'www.example.com' }
  let(:active_charge_start_date) { '2020-05-14' }

  describe '.id' do
    it 'returns a proper id' do
      expect(subject.id).to eq(id)
    end
  end

  describe '.name' do
    it 'returns a proper name' do
      expect(subject.name).to eq(name)
    end
  end

  describe '.operator_name' do
    it 'returns a proper value' do
      expect(subject.operator_name).to eq(operator_name)
    end
  end

  describe '.boundary_url' do
    it 'returns a proper url' do
      expect(subject.boundary_url).to eq(url)
    end
  end

  describe '.exemption_url' do
    it 'returns a proper url' do
      expect(subject.exemption_url).to eq(url)
    end
  end

  describe '.active_charge_start_date' do
    it 'returns a proper date active_charge_start_date' do
      expect(subject.active_charge_start_date).to eq(Date.parse(active_charge_start_date))
    end
  end

  describe '.live?' do
    it 'returns true' do
      expect(subject.live?).to eq(true)
    end

    context 'when active_charge_start_date is today' do
      let(:active_charge_start_date) { Time.zone.today.to_s }

      it 'returns true' do
        expect(subject.live?).to eq(true)
      end
    end

    context 'when active_charge_start_date is in the future' do
      let(:active_charge_start_date) { Date.tomorrow.to_s }

      it 'returns false' do
        expect(subject.live?).to eq(false)
      end
    end
  end

  describe '.checked?' do
    it 'returns true' do
      expect(subject.checked?([id])).to eq(true)
    end

    context 'when another caz was selected' do
      let(:another_id) { SecureRandom.uuid }

      it 'returns false' do
        expect(subject.checked?([another_id])).to eq(false)
      end
    end
  end

  describe '.all' do
    subject { described_class.all }

    before do
      caz_list = read_response('caz_list.json')['cleanAirZones']
      allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
    end

    it 'returns an array of CleanAirZone instances' do
      expect(subject).to all(be_a(described_class))
    end

    it 'returns only active CleanAirZone' do
      expect(subject.count).to eq(3)
    end
  end

  describe '.active_cazes' do
    subject { described_class.active_cazes }

    before do
      caz_list ||= read_response('caz_list_active.json')['cleanAirZones']
      stub = caz_list.map { |caz_data| described_class.new(caz_data) }.sort_by(&:name)
      allow(described_class).to receive(:all).and_return(stub)
    end

    it 'returns an array of CleanAirZone instances' do
      expect(subject).to all(be_a(described_class))
    end

    it 'returns only active CleanAirZone' do
      expect(subject.count).to eq(1)
    end
  end

  describe '.charging_starts' do
    context 'when caz name is Birmingham' do
      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('1 June 2021')
      end
    end

    context 'when caz name is Bath' do
      let(:name) { 'Bath' }

      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('15 March 2021')
      end
    end

    context 'when another caz name' do
      let(:name) { 'Birmingham' }

      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('1 June 2021')
      end
    end
  end
end
