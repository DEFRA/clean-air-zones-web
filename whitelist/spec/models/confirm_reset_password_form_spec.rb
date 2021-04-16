# frozen_string_literal: true

require 'rails_helper'

describe ConfirmResetPasswordForm, type: :model do
  subject do
    described_class.new(
      password: password, confirmation: password_confirmation, code: confirmation_code
    )
  end

  let(:password) { 'password' }
  let(:password_confirmation) { 'password' }
  let(:confirmation_code) { '123456' }

  it 'is valid with a proper password' do
    expect(subject).to be_valid
  end

  context 'when password is empty' do
    let(:password) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('password.errors.password_required'))
    end
  end

  context 'when confirmation code is empty' do
    let(:confirmation_code) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('password.errors.code_required'))
    end
  end

  context 'when password confirmation is empty' do
    let(:password_confirmation) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('password.errors.password_required'))
    end
  end

  context 'when password confirmation is different' do
    let(:password_confirmation) { 'other_password' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('password.errors.password_equality'))
    end
  end
end
