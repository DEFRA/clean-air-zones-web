# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::NonPrimaryUsersController - GET #non_primary_account_details' do
  subject { get non_primary_users_account_details_path }

  before { mock_account_details }

  context 'when user is not owner' do
    before do
      sign_in create_user
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:non_primary_account_details)
    end
  end

  context 'when user is an owner' do
    before { sign_in create_owner }

    it 'redirects to the not found page' do
      expect(subject).to redirect_to(not_found_path)
    end
  end
end
