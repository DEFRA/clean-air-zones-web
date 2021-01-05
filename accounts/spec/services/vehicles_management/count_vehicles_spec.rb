# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::CountVehicles do
  subject { described_class.call(file: file) }

  let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.csv') }
  let(:file) { fixture_file_upload(file_path) }

  describe '#call' do
    it 'returns a proper value' do
      expect(subject).to eq(5)
    end
  end
end
