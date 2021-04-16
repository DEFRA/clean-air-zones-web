# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::SubmissionMethodForm do
  subject { described_class.new(choose_method: choose_method) }

  let(:choose_method) { 'upload' }
  let(:error) { I18n.t('submission_method_form.errors.submission_method_missing') }

  it { is_expected.to be_valid }

  describe '.manual?' do
    it { is_expected.not_to be_manual }
  end

  context 'when method is manual' do
    let(:choose_method) { 'manual' }

    it { is_expected.to be_valid }

    describe '.manual?' do
      it { is_expected.to be_manual }
    end
  end

  context 'when different method is submitted' do
    let(:choose_method) { 'test' }

    it { is_expected.not_to be_valid }

    it 'returns a proper error' do
      subject.valid?
      expect(subject.errors[:choose_method]).to eq([error])
    end
  end

  context 'when method is nil' do
    let(:choose_method) { nil }

    it { is_expected.not_to be_valid }

    it 'returns a proper error' do
      subject.valid?
      expect(subject.errors[:choose_method]).to eq([error])
    end
  end
end
