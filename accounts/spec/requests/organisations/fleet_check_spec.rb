# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #how_many_vehicles', type: :request do
  subject { get how_many_vehicles_organisations_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
