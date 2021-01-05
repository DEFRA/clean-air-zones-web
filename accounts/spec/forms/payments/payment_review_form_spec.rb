# frozen_string_literal: true

require 'rails_helper'

describe Payments::PaymentReviewForm, type: :model do
  subject { described_class.new(confirmation) }

  before { subject.valid? }

  context 'when confirmation equals yes' do
    let(:confirmation) { 'yes' }

    it { is_expected.to be_valid }

    describe '.confirmed?' do
      it 'returns true' do
        expect(subject.confirmed?).to eq(true)
      end
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      error_message = I18n.t('payment_review.errors.confirmation_alert')
      expect(subject.errors.messages[:confirmation]).to include(error_message)
    end
  end
end
