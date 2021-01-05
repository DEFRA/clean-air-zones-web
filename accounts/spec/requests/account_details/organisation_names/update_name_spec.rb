# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::PrimaryUsersController - GET #update_name' do
  subject { get update_name_primary_users_path(params: { company_name: company_name }) }

  let(:company_name) { 'Company Name' }
  let(:account_id) { @uuid }

  context 'when user is an owner' do
    before { sign_in create_owner(account_id: account_id) }

    context 'when valid parameter is provided' do
      before { allow(AccountsApi::Accounts).to receive(:update_company_name).and_return(true) }

      it 'calls AccountsApi::Accounts.update_company_name with correct params' do
        expect(AccountsApi::Accounts)
          .to receive(:update_company_name)
          .with(account_id: account_id, company_name: company_name)
          .and_return(true)
        subject
      end

      it 'redirects to primary user account maintenance page' do
        expect(subject).to redirect_to(primary_users_account_details_path)
      end
    end

    context 'when api returns 422 error' do
      before do
        allow(AccountsApi::Accounts).to receive(:update_company_name).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'duplicate')
        )
        subject
      end

      it 'assigns error variable with a proper error message' do
        expect(assigns(:error)).to eq(I18n.t('company_name.errors.duplicate_alternative'))
      end

      it 'renders the view' do
        expect(response).to render_template(:edit_name)
      end
    end

    context 'when form is invalid' do
      let(:company_name) { '!##' }

      before { subject }

      it 'assigns error variable with a proper error message' do
        expect(assigns(:error)).to eq(I18n.t('company_name_form.company_name_invalid_format'))
      end

      it 'renders the view' do
        expect(response).to render_template(:edit_name)
      end

      it 'does not make an api call' do
        expect(AccountsApi::Accounts).not_to receive(:update_company_name)
      end
    end
  end

  context 'when user is not owner' do
    before { sign_in create_user }

    it 'redirects to the not found page' do
      expect(subject).to redirect_to(not_found_path)
    end
  end

  it_behaves_like 'a login required'
end
