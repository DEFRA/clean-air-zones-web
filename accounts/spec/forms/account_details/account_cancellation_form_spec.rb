# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::AccountCancellationForm, type: :model do
  subject { described_class.new(reason: reason) }

  let(:reason) { 'NON_OPERATIONAL_BUSINESS' }

  before { subject.valid? }

  context 'when params are valid' do
    it { is_expected.to be_valid }
  end

  context 'when a reason is missing' do
    let(:reason) { nil }

    it { is_expected.not_to be_valid }

    it 'has a proper reason missing message' do
      expect(subject.errors.messages[:reason]).to(
        include(I18n.t('account_cancellation_form.reason_missing'))
      )
    end
  end

  context 'when a reason is not present on the values list' do
    let(:reason) { 'INVALID-REASON' }

    it { is_expected.not_to be_valid }

    it 'has a proper reason missing message' do
      expect(subject.errors.messages[:reason]).to(include('is not included in the list'))
    end
  end
end
