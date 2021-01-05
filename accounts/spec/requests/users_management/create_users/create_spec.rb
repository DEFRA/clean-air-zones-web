# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - POST #create' do
  subject { post users_path, params: params }

  let(:params) { { new_user: { 'name': name, 'email': email } } }
  let(:name) { 'New User' }
  let(:email) { 'new_user@example.com' }

  context 'correct permissions' do
    before do
      mock_actual_account_name
      mock_users
      allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true)
      sign_in manage_users_user
      add_to_session({ new_user: { name: name, email: email } })
    end

    context 'when params are valid' do
      it 'redirects to the add permissions page' do
        expect(subject).to redirect_to(add_permissions_users_path)
      end
    end

    context 'when params are not valid' do
      let(:name) { '' }

      it 'renders the view' do
        expect(subject).to render_template(:new)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
