# frozen_string_literal: true

require 'rails_helper'

describe ResetPasswordForm, type: :model do
  subject { described_class.new(email_address: email_address) }

  let(:email_address) { 'test@example.com' }

  %w[test@example.com test.test@example.com].each do |value|
    let(:email_address) { value }

    it 'is valid with a proper email' do
      expect(subject).to be_valid
    end
  end

  context 'when email_address is empty' do
    let(:email_address) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email_address]).to include(
        I18n.t('reset_password_form.email_missing')
      )
    end
  end

  context 'when invalid email format' do
    %w[
      user.example.com test@informed..com test.@informed.com test@@informed.com test@info@rmed.com
    ].each do |value|
      let(:email_address) { value }

      it 'is not valid' do
        expect(subject).not_to be_valid
      end

      it 'has a proper error message' do
        subject.valid?
        expect(subject.errors.messages[:email_address]).to include(
          I18n.t('reset_password_form.email_invalid_format')
        )
      end
    end
  end

  context 'when email is too long' do
    let(:email_address) { "#{SecureRandom.alphanumeric(36)}@email.com" }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email_address]).to include(
        I18n.t(
          'input_form.errors.maximum_length',
          attribute: 'Email address'
        )
      )
    end
  end
end
