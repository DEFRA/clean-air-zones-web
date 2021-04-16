# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::PaginatedFleet, type: :model do
  subject { described_class.new(data, page, per_page) }

  let(:size) { 41 }
  let(:page) { 3 }
  let(:per_page) { 10 }
  let(:data) do
    {
      'vehicles' => read_response('vehicles_management/vehicles.json')['vehicles'],
      'pageCount' => (size / per_page.to_f).ceil,
      'totalVehiclesCount' => size
    }
  end

  describe '.page' do
    it 'returns page value' do
      expect(subject.page).to eq(page)
    end
  end

  describe '.total_pages' do
    it 'returns pageCount value' do
      expect(subject.total_pages).to eq(data['pageCount'])
    end
  end

  describe '.total_vehicles_count' do
    it 'returns size value' do
      expect(subject.total_vehicles_count).to eq(size)
    end
  end

  describe '.per_page' do
    it 'returns per_page value' do
      expect(subject.per_page).to eq(per_page)
    end
  end

  describe '.range_start' do
    context 'when on the first page' do
      let(:page) { 1 }

      it 'returns 1' do
        expect(subject.range_start).to eq(1)
      end
    end

    context 'when on the other page' do
      it 'returns correct value' do
        expect(subject.range_start).to eq(21)
      end
    end
  end

  describe '.range_end' do
    context 'when on the first page' do
      let(:page) { 1 }

      it 'returns 1' do
        expect(subject.range_end).to eq(per_page)
      end
    end

    context 'when on the other page' do
      it 'returns correct value' do
        expect(subject.range_end).to eq(30)
      end
    end

    context 'when on the last page' do
      let(:page) { 6 }

      it 'returns size' do
        expect(subject.range_end).to eq(size)
      end
    end
  end

  describe '.results_per_page' do
    context 'when vehicles size is 11' do
      let(:size) { 11 }

      it 'returns per_page value' do
        expect(subject.results_per_page).to eq([10, 20])
      end
    end

    context 'when vehicles size is 21' do
      let(:size) { 21 }

      it 'returns per_page value' do
        expect(subject.results_per_page).to eq([10, 20, 30])
      end
    end

    context 'when vehicles size is 31' do
      let(:size) { 31 }

      it 'returns per_page value' do
        expect(subject.results_per_page).to eq([10, 20, 30, 40])
      end
    end

    context 'when vehicles size is 41' do
      let(:size) { 41 }

      it 'returns per_page value' do
        expect(subject.results_per_page).to eq([10, 20, 30, 40, 50])
      end
    end

    context 'when vehicles size more than 40' do
      it 'returns per_page value' do
        expect(subject.results_per_page).to eq([10, 20, 30, 40, 50])
      end
    end
  end
end
