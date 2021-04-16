# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::PrimaryUsersController - GET #edit_name', type: :request do
  subject { get edit_name_primary_users_path }

  before { mock_account_details }

  context 'when user is an owner' do
    before do
      sign_in create_owner
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:edit_name)
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
