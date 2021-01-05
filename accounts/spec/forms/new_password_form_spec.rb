# frozen_string_literal: true

require 'rails_helper'

describe NewPasswordForm, type: :model do
  subject do
    described_class.new(password: password, password_confirmation: confirmation)
  end

  let(:password) { 'password' }
  let(:confirmation) { password }

  before { subject.valid? }

  it 'is valid with a proper password' do
    expect(subject).to be_valid
  end

  context 'when password is empty' do
    let(:password) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper password message' do
      expect(subject.errors[:password])
        .to include(I18n.t('new_password_form.errors.password_missing'))
    end
  end

  context 'when password confirmation is empty' do
    let(:confirmation) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper password confirmation message' do
      expect(subject.errors[:password_confirmation])
        .to include(I18n.t('new_password_form.errors.password_confirmation_missing'))
    end
  end

  context 'when password confirmation is different' do
    let(:confirmation) { 'other_password' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper password message' do
      expect(subject.errors[:password])
        .to include(I18n.t('new_password_form.errors.password_not_equal'))
    end

    it 'has a proper password confirmation message' do
      expect(subject.errors[:password_confirmation])
        .to include(I18n.t('new_password_form.errors.password_not_equal'))
    end
  end
end
