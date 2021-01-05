# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::SetUpAccountForm, type: :model do
  subject { described_class.new(params: request_params) }

  let(:request_params) do
    {
      token: token,
      password: password,
      password_confirmation: confirmation
    }
  end

  let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
  let(:password) { 'Pa$$w0rd12345' }
  let(:confirmation) { 'Pa$$w0rd12345' }

  context 'when passwords meet requirements and token is valid' do
    before do
      subject.valid?
      allow(AccountsApi::Auth).to receive(:set_password).and_return(true)
    end

    it { is_expected.to be_valid }

    it 'makes an api call on submit' do
      expect(AccountsApi::Auth)
        .to receive(:set_password)
        .with(token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69', password: 'Pa$$w0rd12345')
      subject.submit
    end
  end

  context 'when passwords meet requirements and token is missing or invalid' do
    let(:token) { '' }

    before do
      allow(AccountsApi::Auth)
        .to receive(:set_password)
        .and_raise(BaseApi::Error400Exception.new(400, '', {}))
    end

    it 'makes an api call on submit that raises an exception' do
      expect(AccountsApi::Auth)
        .to receive(:set_password)
        .with(token: '', password: 'Pa$$w0rd12345')
        .and_raise(BaseApi::Error400Exception.new(400, '', {}))
      subject.submit
    end

    it 'has correct token error message' do
      subject.submit
      error_message = I18n.t('token_form.token_invalid')
      expect(subject.errors.messages[:token]).to include(error_message)
    end

    it 'has no password fields errors' do
      expect(subject.errors.messages[:password]).to eq([])
      expect(subject.errors.messages[:password_confirmation]).to eq([])
    end

    it '.submit is false' do
      expect(subject.submit).to eq(false)
    end
  end

  context 'when passwords do not meet requirements' do
    let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
    let(:password) { 'pass' }
    let(:confirmation) { 'pass' }

    before do
      allow(AccountsApi::Auth)
        .to receive(:set_password)
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
    end

    it 'makes an api call on submit that raises an exception' do
      expect(AccountsApi::Auth)
        .to receive(:set_password)
        .with(token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69', password: 'pass')
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
      subject.submit
    end

    it 'has correct password fields message' do
      subject.submit
      error_message = 'Enter a password at least 12 characters long including at least 1 upper case letter, '\
                      '1 number and a special character'
      expect(subject.errors.messages[:password]).to include(error_message)
      expect(subject.errors.messages[:password_confirmation]).to include(error_message)
    end

    it '.submit is false' do
      expect(subject.submit).to eq(false)
    end
  end

  context 'when password confirmation is missing' do
    let(:confirmation) { '' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(subject.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('new_password_form.errors.password_confirmation_missing')
      expect(subject.errors.messages[:password_confirmation]).to include(error_message)
    end
  end

  context 'when password is missing' do
    let(:password) { '' }
    let(:confirmation) { 'Pa$$w0rd12345' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('new_password_form.errors.password_missing')
      expect(subject.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(subject.errors.messages[:password_confirmation]).to include(error_message)
    end
  end

  context 'when password and confirmation are different' do
    let(:password) { '54321Pa$$w0rd' }
    let(:confirmation) { 'Pa$$w0rd12345' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(subject.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(subject.errors.messages[:password_confirmation]).to include(error_message)
    end
  end

  context 'when neither passwords are provided' do
    let(:password) { '' }
    let(:confirmation) { '' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('new_password_form.errors.password_missing')
      expect(subject.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('new_password_form.errors.password_confirmation_missing')
      expect(subject.errors.messages[:password_confirmation]).to include(error_message)
    end
  end
end
