# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #index' do
  subject { get passwords_path(token: token) }

  let(:token) { @uuid }

  before do
    allow(AccountsApi::Auth).to receive(:validate_password_reset).and_return(true)
  end

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end

  it 'assigns token' do
    subject
    expect(assigns(:token)).to eq(token)
  end

  it 'saves the token in the session' do
    subject
    expect(session[:reset_password_token]).to eq(token)
  end

  it 'calls AccountsApi::Auth.validate_password_reset' do
    expect(AccountsApi::Auth).to receive(:validate_password_reset).with(token: token)
    subject
  end

  context 'without the token' do
    let(:token) { nil }

    it 'redirects to the invalid page' do
      expect(subject).to redirect_to(invalid_passwords_path)
    end
  end

  context 'when token is invalid' do
    before do
      allow(AccountsApi::Auth)
        .to receive(:validate_password_reset)
        .and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
    end

    it 'redirects to the invalid page' do
      expect(subject).to redirect_to(invalid_passwords_path)
    end
  end
end
