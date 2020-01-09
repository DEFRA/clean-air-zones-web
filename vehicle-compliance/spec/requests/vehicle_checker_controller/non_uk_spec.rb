# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #non_uk', type: :request do
  subject { get non_uk_vehicle_checkers_path }

  context 'with VRN in session' do
    before { add_vrn_to_session }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end
  end
end
