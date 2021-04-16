# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #cannot_create', type: :request do
  subject { get cannot_create_organisations_path }

  before { mock_clean_air_zones }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
