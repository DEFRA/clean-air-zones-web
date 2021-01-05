# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::PasswordsController - GET #edit' do
  subject { get edit_password_path }

  context 'when user is an owner' do
    before do
      sign_in create_owner
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:edit)
    end
  end

  context 'when user is not owner' do
    before do
      sign_in create_user
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:edit)
    end
  end

  it_behaves_like 'a login required'
end
