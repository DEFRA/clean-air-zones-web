# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #exemption', type: :request do
  subject(:http_request) { get exemption_vehicle_checkers_path }

  before { add_vrn_to_session }

  it 'returns an ok response' do
    http_request
    expect(response).to have_http_status(:ok)
  end
end
