# frozen_string_literal: true

require 'rails_helper'

describe LogoutController, type: :request do
  describe 'GET #sign_out' do
    subject { get sign_out_path }

    it 'redirects the correct template' do
      expect(subject).to render_template(:sign_out)
    end
  end

  describe 'POST #assign_logout_notice_back_url' do
    subject { post assign_logout_notice_back_url_path(params: params) }

    let(:params) { { logout_notice_back_url: root_path } }

    before { subject }

    it 'assigns correct value to session' do
      expect(session[:logout_notice_back_url]).to eq(root_path)
    end

    it 'returns 204 response' do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #logout_notice' do
    subject { get logout_notice_path }

    before { add_to_session(logout_notice_back_url: root_path) }

    it 'redirects the correct template' do
      expect(subject).to render_template(:logout_notice)
    end

    it 'assigns @back_button_url variable' do
      subject
      expect(assigns(:back_button_url)).to eq(root_path)
    end
  end

  describe 'GET #timedout_user' do
    subject { get timedout_user_path }

    before do
      sign_in create_user
      subject
    end

    it 'redirects to the login page' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'sets correct error to flash[:notice]' do
      expect(flash[:notice]).to eq(I18n.t('inactivity_logout'))
    end
  end
end
