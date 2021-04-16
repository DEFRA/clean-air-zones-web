# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - POST #confirm_set_up', type: :request do
  subject { post set_up_users_path, params: { account_set_up: request_params } }

  let(:request_params) do
    {
      token: token,
      password: password,
      password_confirmation: confirmation
    }
  end

  let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
  let(:password) { 'Pa$$w0rd123456' }
  let(:confirmation) { 'Pa$$w0rd123456' }

  context 'when provided with correct parameters and valid token' do
    before { allow(AccountsApi::Auth).to receive(:set_password).and_return(true) }

    it 'redirects to the set up confirmation page' do
      subject
      expect(response).to redirect_to(set_up_confirmation_users_path)
    end
  end

  context 'when provided with same but invalid passwords' do
    let(:password) { 'pass' }
    let(:confirmation) { 'pass' }

    before do
      allow(AccountsApi::Auth)
        .to receive(:set_password)
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
      subject
    end

    it 'render the view' do
      expect(response).to redirect_to(set_up_users_path)
    end

    it 'provides proper error messages' do
      errors = {
        token: nil,
        password: 'Enter a password at least 12 characters long including at least 1 upper case letter, '\
                   '1 number and a special character',
        password_confirmation: 'Enter a password at least 12 characters long including at least 1 upper case'\
                   ' letter, 1 number and a special character'
      }

      expect(flash[:errors]).to eq(errors)
    end
  end

  context 'when provided with valid passwords but outdated token' do
    let(:password) { 'Pa$$w0rd123456' }
    let(:confirmation) { 'Pa$$w0rd123456' }

    before do
      allow(AccountsApi::Auth)
        .to receive(:set_password)
        .and_raise(BaseApi::Error400Exception.new(400, '', {}))
      subject
    end

    it 'render the view' do
      expect(response).to redirect_to(set_up_users_path)
    end

    it 'provides proper error messages' do
      errors = {
        token: I18n.t('token_form.token_invalid'),
        password: nil,
        password_confirmation: nil
      }

      expect(flash[:errors]).to eq(errors)
    end
  end

  context 'when provided with valid passwords but non-uuid token' do
    let(:token) { '27978cac-non-uuid-token-54fd12e37c69' }
    let(:password) { 'Pa$$w0rd123456' }
    let(:confirmation) { 'Pa$$w0rd123456' }

    before { subject }

    it 'render the view' do
      expect(response).to redirect_to(set_up_users_path)
    end

    it 'provides proper error messages' do
      errors = {
        token: I18n.t('token_form.token_invalid'),
        password: nil,
        password_confirmation: nil
      }

      expect(flash[:errors]).to eq(errors)
    end
  end
end
