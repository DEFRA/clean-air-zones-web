# frozen_string_literal: true

require 'rails_helper'

describe ResetPasswordForm, type: :model do
  subject { described_class.new(email_address_params) }

  let(:email_address_params) do
    {
      email_address: email_address
    }
  end

  let(:email_address) { 'example@email.com' }

  it { is_expected.to be_valid }

  context 'when email_address is empty' do
    let(:email_address) { '' }

    it { expect(subject).not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email_address].join(',')).to include(
        I18n.t('reset_password_form.email_missing')
      )
    end
  end

  context 'when email is in an invalid format' do
    let(:email_address) { 'example_email.com' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email_address].join(',')).to include(
        I18n.t('reset_password_form.email_invalid_format')
      )
    end
  end

  context 'when email_address is too long' do
    let(:email_address) { 'example_email.com' * 3 }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email_address].join(',')).to include(
        I18n.t('input_form.errors.maximum_length', attribute: 'Email address')
      )
    end
  end
end
