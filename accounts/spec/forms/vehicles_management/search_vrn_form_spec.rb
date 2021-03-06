# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::SearchVrnForm, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'ABC123' }

  it { is_expected.to be_valid }
  it { expect(subject.vrn).to eq(vrn) }

  context 'when vrn includes spaces and small letters' do
    let(:vrn) { 'AbC 12 3' }

    it 'removes spaces and upcases vrn' do
      expect(subject.vrn).to eq('ABC123')
    end
  end

  context 'when vrn is empty' do
    let(:vrn) { '' }

    it_behaves_like 'an invalid VrnForm', I18n.t('vrn_form.errors.vrn_missing')
  end

  describe '.error_message' do
    let(:vrn) { nil }

    it 'returns a proper value' do
      subject.valid?
      expect(subject.error_message).to eq('Enter the number plate of the vehicle')
    end
  end
end
