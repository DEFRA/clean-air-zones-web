# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - POST #validate', type: :request do
  subject { post reset_passwords_path, params: { passwords: { email_address: email_address } } }

  let(:email_address) { 'email@example.com' }

  before { allow(AccountsApi::Auth).to receive(:initiate_password_reset).and_return(true) }

  context 'with valid params' do
    it 'returns a redirect to email sent ' do
      expect(subject).to redirect_to(email_sent_passwords_path)
    end

    it 'calls AccountsApi.initiate_password_reset' do
      subject
      expect(AccountsApi::Auth).to have_received(:initiate_password_reset)
        .with(email: email_address, reset_url: passwords_url)
    end
  end

  context 'with invalid params' do
    let(:email_address) { '' }

    it 'renders reset password view' do
      subject
      expect(response).to render_template(:reset)
    end
  end
end
