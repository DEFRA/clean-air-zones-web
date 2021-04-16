# frozen_string_literal: true

require 'rails_helper'

describe ResetPasswordForm, type: :model do
  subject { described_class.new(username) }

  let(:username) { 'wojtek@email.com' }

  it 'is valid with a proper email' do
    expect(subject).to be_valid
  end

  it 'has username set as parameter' do
    expect(subject.parameter).to eq(username)
  end

  context 'when username is empty' do
    let(:username) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('email.errors.required'))
    end
  end

  context 'when invalid email format' do
    let(:username) { 'user.example.com' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('email.errors.invalid_format'))
    end
  end

  context 'when email is too long' do
    let(:username) { "#{SecureRandom.alphanumeric(36)}@email.com" }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      subject.valid?
      expect(subject.message).to eq(I18n.t('email.errors.too_long'))
    end
  end
end
