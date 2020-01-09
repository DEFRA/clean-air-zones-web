# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Caz, type: :model do
  subject(:caz) { described_class.new(data) }

  let(:data) { { 'name' => name, 'cleanAirZoneId' => id, 'boundaryUrl' => url } }
  let(:name) { 'Birmingham' }
  let(:id) { SecureRandom.uuid }
  let(:url) { 'www.example.com' }

  describe '.id' do
    it 'returns a proper id' do
      expect(caz.id).to eq(id)
    end
  end

  describe '.name' do
    it 'returns a proper name' do
      expect(caz.name).to eq(name)
    end
  end

  describe '.boundary_url' do
    it 'returns a proper url' do
      expect(caz.boundary_url).to eq(url)
    end
  end

  describe '.checked?' do
    it 'returns true' do
      expect(caz.checked?([id])).to eq(true)
    end

    context 'when another caz was selected' do
      let(:another_id) { SecureRandom.uuid }

      it 'returns false' do
        expect(caz.checked?([another_id])).to eq(false)
      end
    end
  end
end
