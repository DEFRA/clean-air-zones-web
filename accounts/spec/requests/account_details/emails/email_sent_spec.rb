# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::EmailsController - GET #email_sent', type: :request do
  subject { get email_sent_primary_users_path }

  let(:owner_email) { 'new@email.com' }

  before do
    sign_in create_owner
    add_to_session(owners_new_email: owner_email)
    subject
  end

  it 'returns a 200 OK status' do
    expect(response).to have_http_status(:ok)
  end

  it 'assigns email variable' do
    expect(assigns(:email)).to eq owner_email
  end
end
