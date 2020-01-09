# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #user_confirm_details', type: :request do
  subject(:http_request) do
    get user_confirm_details_vehicle_checkers_path, params: {
      'confirm-vehicle' => confirmation,
      'undetermined' => 'false'
    }
  end

  let(:confirmation) { 'yes' }

  before do
    add_vrn_to_session
    http_request
  end

  context 'when user confirms details' do
    it 'redirects to enter details page' do
      expect(response).to redirect_to(caz_selection_air_zones_path)
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to incorrect details page' do
      expect(response).to redirect_to(incorrect_details_vehicle_checkers_path)
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'redirects to confirm details page' do
      expect(response).to redirect_to(confirm_details_vehicle_checkers_path)
    end
  end
end
