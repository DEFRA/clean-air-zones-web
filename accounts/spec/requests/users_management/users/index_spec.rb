# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::UsersController - GET #index' do
  subject { get users_path }

  context 'correct permissions' do
    before do
      sign_in manage_users_user
      mock_actual_account_name
      mock_users
    end

    it 'renders the view' do
      expect(subject).to render_template(:index)
    end

    context 'when last visited page is confirmation user' do
      subject { get users_path, headers: { 'HTTP_REFERER': confirmation_users_path } }

      before do
        add_to_session(new_user: {})
        subject
      end

      it 'renders the view' do
        expect(response).to render_template(:index)
      end

      it 'clears the new_user' do
        expect(session[:new_user]).to eq(nil)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
