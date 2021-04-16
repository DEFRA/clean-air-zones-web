# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #sign_in_details', type: :request do
  subject { get sign_in_details_organisations_path }

  before do
    add_to_session(new_account: { account_id: SecureRandom.uuid })
    subject
  end

  it 'returns a 200 OK status' do
    expect(response).to have_http_status(:ok)
  end
end
