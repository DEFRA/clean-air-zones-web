# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - GET #new' do
  subject { get new_user_path }

  context 'correct permissions' do
    before do
      mock_actual_account_name
      sign_in manage_users_user
    end

    context 'when api returns some users' do
      before do
        mock_users
        subject
      end

      it 'renders the view' do
        expect(response).to render_template(:new)
      end

      it 'assigns @back_button_url variable' do
        expect(assigns(:back_button_url)).to eq(users_path)
      end
    end

    context 'when api returns empty users' do
      before do
        mock_empty_users_list
        subject
      end

      it 'renders the view' do
        expect(response).to render_template(:new)
      end

      it 'assigns @back_button_url variable' do
        expect(assigns(:back_button_url)).to eq(dashboard_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
