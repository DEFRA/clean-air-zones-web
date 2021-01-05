# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - POST #add_permissions' do
  subject { post add_permissions_users_path, params: params.stringify_keys }

  let(:params) { { new_user: { 'permissions': permissions } } }
  let(:permissions) { %w[MANAGE_USERS] }

  context 'correct permissions' do
    before do
      allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true)
      allow(AccountsApi::Accounts).to receive(:user_invitations).and_return(true)
      mock_users
      sign_in manage_users_user
      add_to_session({ new_user: { name: 'New User', email: 'new_user@example.com' } })
    end

    context 'when params are valid' do
      it 'redirects to the confirmation users page' do
        expect(subject).to redirect_to(confirmation_users_path)
      end
    end

    context 'when params are not valid' do
      let(:permissions) { nil }

      it 'renders the view' do
        expect(subject).to render_template(:add_permissions)
      end
    end

    context 'when user email is duplicated' do
      before do
        allow(AccountsApi::Accounts).to receive(:user_validations).and_raise(
          BaseApi::Error400Exception.new(400, '', '')
        )
      end

      it 'redirects to the add a user page' do
        expect(subject).to redirect_to(new_user_path)
      end
    end

    context 'when no new user data in session' do
      before { add_to_session({ new_user: {} }) }

      it 'redirects to the add a user page' do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
