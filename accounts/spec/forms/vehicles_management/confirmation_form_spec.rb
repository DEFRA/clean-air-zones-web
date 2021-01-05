# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::ConfirmationForm, type: :model do
  subject { described_class.new(confirmation) }

  let(:confirmation) { 'yes' }

  it { is_expected.to be_valid }

  describe '.confirmed?' do
    context 'when confirmation equals yes' do
      it 'returns true' do
        expect(subject.confirmed?).to eq(true)
      end
    end

    context 'when confirmation equals no' do
      let(:confirmation) { 'no' }

      it 'returns false' do
        expect(subject.confirmed?).to eq(false)
      end
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it { is_expected.not_to be_valid }

    before do
      subject.valid?
    end

    it 'has a proper error message' do
      expect(subject.errors.messages[:confirmation]).to include('You must choose an answer')
    end
  end
end