# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #reset' do
  subject { get reset_passwords_path, headers: { 'HTTP_REFERER': last_visited_path } }

  let(:last_visited_path) { nil }

  context 'when last visited page is nil' do
    before { subject }

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:reset)
    end
  end

  context 'when last visited page is account set up page' do
    before { subject }

    let(:last_visited_path) { set_up_confirmation_users_path }

    it 'renders the view' do
      expect(response).to render_template(:reset)
    end

    it 'assigns @back_button_url variable' do
      expect(assigns(:back_button_url)).to eq(set_up_confirmation_users_path)
    end
  end

  context 'when reset_password_back_button_url in session' do
    before do
      add_to_session(reset_password_back_button_url: new_user_session_path)
      subject
    end

    it 'assigns @back_button_url variable' do
      expect(assigns(:back_button_url)).to eq(new_user_session_path)
    end

    it 'renders the view' do
      expect(response).to render_template(:reset)
    end
  end
end
