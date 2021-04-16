# frozen_string_literal: true

require 'rails_helper'

describe Organisations::EmailAndPasswordForm, type: :model do
  subject { described_class.new(params) }

  let(:params) do
    {
      email: email,
      email_confirmation: email_confirmation,
      password: password,
      password_confirmation: password_confirmation
    }
  end

  let(:email) { 'example@email.com' }
  let(:email_confirmation) { 'example@email.com' }
  let(:password) { '8NAOTpMkx2%9' }
  let(:password_confirmation) { '8NAOTpMkx2%9' }

  before { subject.valid? }

  it { is_expected.to be_valid }

  context 'when email and email_confirmation fields' do
    context 'when email is empty' do
      let(:email) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:email]).to include(
          I18n.t('email_and_password_form.email_missing')
        )
      end
    end

    context 'when email is in an invalid format' do
      let(:email) { 'example_email.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:email]).to include(
          I18n.t('input_form.errors.invalid_format', attribute: 'Email')
        )
      end
    end

    context 'when email is too long' do
      let(:email) { 'example_email.com' * 3 }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:email]).to include(
          I18n.t('input_form.errors.maximum_length', attribute: 'Email')
        )
      end
    end

    context 'when email confirmation is different' do
      let(:email_confirmation) { 'different_example@email.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:email]).to include(
          I18n.t('email.errors.email_equality')
        )
      end
    end

    context 'when email confirmation is blank' do
      let(:email_confirmation) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:email_confirmation]).to include(
          I18n.t('email_and_password_form.email_confirmation_missing')
        )
      end
    end

    context 'when email and email confirmation are in an invalid format' do
      let(:email) { 'example_email.com' }
      let(:email_confirmation) { 'example_email.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper email error message' do
        expect(subject.errors.messages[:email]).to include(
          I18n.t('input_form.errors.invalid_format', attribute: 'Email')
        )
      end

      it 'has a proper email_confirmation error message' do
        expect(subject.errors.messages[:email_confirmation]).to include(
          I18n.t('input_form.errors.invalid_format', attribute: 'Email confirmation')
        )
      end
    end
  end

  context 'when password and password_confirmation fields' do
    context 'when password is empty' do
      let(:password) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:password]).to include(
          I18n.t('email_and_password_form.password_missing')
        )
      end
    end

    context 'when password is too long' do
      let(:password) { '8NAOTpMkx2%9' * 4 }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:password]).to include(
          I18n.t('input_form.errors.maximum_length', attribute: 'Password')
        )
      end
    end

    context 'when password and password confirmation is different' do
      let(:password) { 'Different_Mkx2%9' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:password]).to include(
          'Password and password confirmation must be the same'
        )
      end
    end

    context 'when password_confirmation is empty' do
      let(:password_confirmation) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:password_confirmation]).to include(
          I18n.t('email_and_password_form.password_confirmation_missing')
        )
      end
    end

    context 'when password_confirmation is too long' do
      let(:password_confirmation) { '8NAOTpMkx2%9' * 4 }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(subject.errors.messages[:password_confirmation]).to include(
          I18n.t('input_form.errors.maximum_length', attribute: 'Password confirmation')
        )
      end
    end
  end
end
