# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #email_verified' do
  subject { get email_verified_organisations_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
