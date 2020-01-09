# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #cannot_determinate', type: :request do
  subject { get cannot_determinate_vehicle_checkers_path }

  before { add_vrn_to_session }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
