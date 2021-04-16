# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::EditUsersController - GET #edit', type: :request do
  subject { get edit_user_path(SecureRandom.uuid) }

  context 'when correct permissions' do
    before do
      mock_clean_air_zones
      sign_in manage_users_user
    end

    context 'when user is exist in db' do
      before { mock_user_details }

      it 'renders the view' do
        expect(subject).to render_template(:edit)
      end
    end

    context 'when user is not exist in db' do
      before do
        allow(AccountsApi::Users).to receive(:user)
          .and_raise(BaseApi::Error404Exception.new(404, '', {}))
      end

      it 'redirects to the not_found page' do
        expect(subject).to redirect_to not_found_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
