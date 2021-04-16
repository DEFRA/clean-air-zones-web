# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - GET #exemption', type: :request do
  subject { get exemption_vehicle_checkers_path }

  before { add_vrn_to_session }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
