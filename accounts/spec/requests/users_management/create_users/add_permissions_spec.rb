# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - GET #add_permissions', type: :request do
  subject { get add_permissions_users_path }

  context 'when correct permissions' do
    before do
      sign_in manage_users_user
      add_to_session({ new_user: { email: 'new_user@example.com', name: 'New User' } })
      mock_clean_air_zones
      mock_users
    end

    it 'renders the view' do
      expect(subject).to render_template(:add_permissions)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
