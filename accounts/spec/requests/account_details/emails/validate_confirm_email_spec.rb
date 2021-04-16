# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsDetails::EmailsController - GET #validate_confirm_email', type: :request do
  subject do
    get validate_confirm_email_primary_users_path(
      token: 'token',
      params: {
        passwords: {
          password: 'password',
          password_confirmation: 'password'
        }
      }
    )
  end

  before do
    stub = instance_double('AccountDetails::UpdateEmail',
                           valid?: valid?,
                           errors: [],
                           new_user_email: email,
                           password: 'password')
    allow(AccountDetails::UpdateEmail).to receive(:call).and_return(stub)
  end

  let(:valid?) { true }
  let(:email) { 'john.doe@example.com' }

  context 'when user is logged in' do
    context 'with is an owner' do
      before do
        sign_in create_owner
        subject
      end

      context 'with params are valid' do
        it 'redirects to the dashboard page' do
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'with params are not valid' do
        let(:valid?) { false }

        it 'returns a 200 OK status' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the view' do
          expect(response).to render_template(:confirm_email)
        end
      end
    end
  end

  context 'when user is not logged in' do
    before do
      allow(AccountsApi::Auth).to receive(:confirm_email).and_return(email)
      allow(AccountsApi::Auth).to receive(:sign_in).and_return(
        'email' => email,
        'accountUserId' => SecureRandom.uuid,
        'accountId' => SecureRandom.uuid,
        'accountName' => "Royal Mail's",
        'owner' => true
      )
      subject
    end

    it 'redirects to the dashboard page' do
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
