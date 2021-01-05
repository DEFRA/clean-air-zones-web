# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #verification_expired' do
  subject { get verification_expired_organisations_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
