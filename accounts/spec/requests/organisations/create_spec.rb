# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - POST #create' do
  subject { post new_credentials_organisations_path, params: params }

  let(:params) { { organisations: organization_params } }
  let(:organization_params) do
    {
      email: email,
      email_confirmation: email,
      password: password,
      password_confirmation: password
    }
  end
  let(:user) { User.new(email: email, sub: @uuid) }
  let(:email) { 'email@example.com' }
  let(:account_id) { @uuid }
  let(:password) { '8NAOTpMkx2%9' }

  context 'with company name in the session' do
    before do
      allow(Organisations::CreateUserAccount).to receive(:call).and_return(user)
      add_to_session(new_account: { 'account_id': account_id })
    end

    context 'with valid params' do
      it 'redirects to the email sent page' do
        subject
        expect(response).to redirect_to(email_sent_organisations_path)
      end

      it 'calls CreateAccountService with proper params' do
        expect(Organisations::CreateUserAccount)
          .to receive(:call)
          .with(
            organisations_params: strong_params(organization_params),
            account_id: account_id,
            verification_url: email_verification_organisations_url
          )
        subject
      end
    end

    context 'with invalid params' do
      before do
        allow(Organisations::CreateUserAccount).to receive(:call)
          .and_raise(NewPasswordException.new({}))
      end

      it 'redirects the account details view' do
        subject
        expect(response).to render_template(:new_credentials)
      end
    end
  end

  context 'without company name in session' do
    it_behaves_like 'company name is missing'
  end
end
