# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - GET #enter_details', type: :request do
  subject { get enter_details_vehicle_checkers_path }

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end
end
