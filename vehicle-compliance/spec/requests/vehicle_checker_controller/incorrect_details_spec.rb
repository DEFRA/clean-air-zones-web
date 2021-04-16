# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - GET #incorrect_details', type: :request do
  subject { get incorrect_details_vehicle_checkers_path }

  before { add_vrn_to_session }

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end
end
